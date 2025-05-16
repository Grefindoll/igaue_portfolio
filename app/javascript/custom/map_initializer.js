// app/javascript/custom/map_initializer.js

let map;
let currentInfoWindow = null;
let activeMarkers = [];
let allFlowerSpotsData = [];

function createInfoWindowContentForSpot(spot) {
  let content = `<strong>${spot.name}</strong>`;
  content += `<br><a href="${spot.show_path}">詳細を見る</a>`;
  return `<div>${content}</div>`;
}

function getSelectedFilterCriteria() {
  const criteria = {
    peak_season_months: [],
    parking: '',
    fee_type: ''
  };
  const monthCheckboxes = document.querySelectorAll('input[name="filter_peak_season_months"]:checked');
  monthCheckboxes.forEach(checkbox => {
    criteria.peak_season_months.push(parseInt(checkbox.value));
  });
  const parkingSelect = document.getElementById('filter_parking');
  if (parkingSelect) criteria.parking = parkingSelect.value;
  const feeTypeSelect = document.getElementById('filter_fee_type');
  if (feeTypeSelect) criteria.fee_type = feeTypeSelect.value;
  // console.log("現在の絞り込み条件:", criteria);
  return criteria;
}

async function displayMarkersOnMap(spotsData) {
  if (!map) {
    console.warn("displayMarkersOnMap: mapオブジェクトが初期化されていません。");
    return;
  }
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
  const { InfoWindow } = await google.maps.importLibrary("maps");
  activeMarkers.forEach(marker => marker.map = null);
  activeMarkers = [];
  if (!spotsData || spotsData.length === 0) {
    // console.log("displayMarkersOnMap: 表示するお花畑データがありません。");
    return;
  }
  spotsData.forEach(spot => {
    if (spot.latitude && spot.longitude) {
      const marker = new AdvancedMarkerElement({
        map: map,
        position: { lat: parseFloat(spot.latitude), lng: parseFloat(spot.longitude) },
        title: spot.name
      });
      marker.addListener('click', () => {
        if (currentInfoWindow) currentInfoWindow.close();
        const infoWindow = new InfoWindow({ content: createInfoWindowContentForSpot(spot) });
        infoWindow.open(map, marker);
        currentInfoWindow = infoWindow;
      });
      activeMarkers.push(marker);
    }
  });
  if (activeMarkers.length > 0) {
    const bounds = new google.maps.LatLngBounds();
    activeMarkers.forEach(marker => bounds.extend(marker.position));
    map.fitBounds(bounds);
    if (activeMarkers.length === 1 && map.getZoom() > 12) map.setZoom(12);
    else if (map.getZoom() > 16) map.setZoom(16);
  }
}

function applyFiltersAndRedrawMarkers() {
  const criteria = getSelectedFilterCriteria();
  const filteredSpots = allFlowerSpotsData.filter(spot => {
    let matchesMonth = true;
    if (criteria.peak_season_months.length > 0) {
      matchesMonth = Array.isArray(spot.peak_season_months) &&
                     criteria.peak_season_months.some(selectedMonth =>
                       spot.peak_season_months.includes(selectedMonth)
                     );
    }
    let matchesParking = true;
    if (criteria.parking !== "") {
      matchesParking = (spot.parking === criteria.parking);
    }
    let matchesFeeType = true;
    if (criteria.fee_type !== "") {
      matchesFeeType = (spot.fee_type === criteria.fee_type);
    }
    return matchesMonth && matchesParking && matchesFeeType;
  });
  displayMarkersOnMap(filteredSpots);
  // console.log(`絞り込み適用後: ${filteredSpots.length}件のお花畑を表示中`);
}

// --- ここから変更点 ---
/**
 * 地図の初期化、お花畑データの取得、マーカーの表示、イベントリスナーの設定を行います。
 * この関数は turbo:load イベントで呼び出されることを想定しています。
 */
async function initializeHanamap() {
  const mapDiv = document.getElementById('map');
  if (!mapDiv) {
    // console.log("initializeHanamap: 地図表示用のdiv要素(id='map')が見つかりません。");
    return; 
  }

  // Google Maps APIがロードされているか確認
  if (typeof google === 'undefined' || typeof google.maps === 'undefined' || typeof google.maps.importLibrary === 'undefined') {
    console.error("initializeHanamap: Google Maps APIがロードされていません。少し待ってからリトライするか、APIの読み込みを確認してください。");
    // ここで数秒後にリトライするような処理を入れることも検討できますが、まずはAPIロードを待ちます。
    // 簡単なリトライ例: setTimeout(initializeHanamap, 1000); // 1秒後に再試行 (無限ループに注意)
    return;
  }
  
  // もし地図が既に初期化済みなら、何もしない（重複初期化の防止）
  // ただし、Turbo Driveでページが入れ替わる場合、mapDiv自体が新しくなるので、
  // この map 変数だけでのチェックは完全ではないかもしれません。
  // より堅牢にするなら、mapDivに初期化済みフラグをdata属性で持たせるなど。
  if (map && mapDiv.classList.contains('map-initialized')) {
    // console.log("initializeHanamap: 地図は既に初期化済みです。");
    // return; // 状況に応じてreturnするか、フィルタフォームの再設定だけ行うかなど検討
  }


  if (mapDiv.dataset.flowerSpots) {
    try {
      allFlowerSpotsData = JSON.parse(mapDiv.dataset.flowerSpots);
    } catch (e) {
      console.error("initializeHanamap: お花畑データのJSONパースに失敗しました。", e);
      allFlowerSpotsData = [];
    }
  } else {
    allFlowerSpotsData = [];
    // console.warn("initializeHanamap: HTMLのdata-flower-spots属性にお花畑データが見つかりません。");
  }

  const { Map } = await google.maps.importLibrary("maps");
  const initialPosition = { lat: 36.2048, lng: 138.2529 };
  const initialZoom = (allFlowerSpotsData && allFlowerSpotsData.length > 0) ? 5 : 6;

  // 前の地図インスタンスがあれば破棄するなどの処理が必要な場合もあるが、
  // turbo:loadでmapDivが作り直されるなら、新しいmapインスタンスを作れば良い。
  map = new Map(mapDiv, {
    center: initialPosition,
    zoom: initialZoom,
    mapId: 'HANAMAP_MAIN_MAP_ID'
  });
  mapDiv.classList.add('map-initialized'); // 初期化済みフラグとしてクラスを追加

  map.addListener('click', () => {
    if (currentInfoWindow) {
      currentInfoWindow.close();
      currentInfoWindow = null;
    }
  });

  displayMarkersOnMap(allFlowerSpotsData);

  const filterForm = document.getElementById('filter-form');
  if (filterForm) {
    // Turbo Driveでページが読み込まれるたびにイベントリスナーが重複して登録されるのを防ぐため、
    // 一旦既存のリスナーを削除するか、リスナー内で状態を管理するなどの工夫が望ましい。
    // ここではシンプルに再登録しますが、より複雑な場合は注意が必要です。
    // 簡単な重複防止策: filterFormにフラグを持たせるなど。
    if (!filterForm.dataset.listenerAttached) {
        filterForm.addEventListener('change', applyFiltersAndRedrawMarkers);
        filterForm.dataset.listenerAttached = 'true';
    }
  } else {
    // console.warn("initializeHanamap: 絞り込みフォームの要素(id='filter-form')が見つかりません。");
  }
  // console.log("initializeHanamap: 地図の初期化処理が完了しました。");
}

// Turbo Drive のページ読み込み完了イベントをリッスンします。
// これにより、通常のページロード時と、Turboによるページ遷移時の両方で initializeHanamap が呼び出されます。
document.addEventListener("turbo:load", function() {
  // console.log("turbo:load イベント発生");
  // 地図を表示する要素があるページでのみ初期化処理を呼び出す
  if (document.getElementById('map')) {
    initializeHanamap();
  }
});
