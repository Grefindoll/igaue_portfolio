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
  return criteria;
}

async function displayMarkersOnMap(spotsData) {
  if (!map) {
    return;
  }
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
  const { InfoWindow } = await google.maps.importLibrary("maps");
  activeMarkers.forEach(marker => marker.map = null);
  activeMarkers = [];
  if (!spotsData || spotsData.length === 0) {
    return;
  }
  spotsData.forEach(spot => {
    if (spot.latitude && spot.longitude) {
      const marker = new AdvancedMarkerElement({
        map: map,
        position: { lat: parseFloat(spot.latitude), lng: parseFloat(spot.longitude) },
        title: spot.name
      });
      marker.addListener('click', () => { // Google Maps APIの推奨は 'gmp-click' ですが、既存の動作を維持します
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
    let matchesParking = true;
    let matchesFeeType = true;

    // 月の絞り込み
    if (criteria.peak_season_months.length > 0) {
      if (!Array.isArray(spot.peak_season_months)) {
        matchesMonth = false;
      } else {
        matchesMonth = criteria.peak_season_months.some(selectedMonth =>
          spot.peak_season_months.includes(selectedMonth)
        );
      }
    }

    // 駐車場の絞り込み
    if (criteria.parking !== "" && criteria.parking !== "unknown") {
      matchesParking = (spot.parking === criteria.parking);
    }

    // 料金体系の絞り込み
    if (criteria.fee_type !== "" && criteria.fee_type !== "unknown") {
      matchesFeeType = (spot.fee_type === criteria.fee_type);
    }

    return matchesMonth && matchesParking && matchesFeeType;
  });
  displayMarkersOnMap(filteredSpots);
}

async function initializeHanamap() {
  const mapDiv = document.getElementById('map');
  if (!mapDiv) {
    return;
  }

  if (typeof google === 'undefined' || typeof google.maps === 'undefined' || typeof google.maps.importLibrary === 'undefined') {
    console.error("initializeHanamap: Google Maps APIがロードされていません。");
    return;
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
  }

  const { Map } = await google.maps.importLibrary("maps");
  const initialPosition = { lat: 36.2048, lng: 138.2529 }; // 日本中心あたり
  const initialZoom = (allFlowerSpotsData && allFlowerSpotsData.length > 0) ? 5 : 6;

  map = new Map(mapDiv, {
    center: initialPosition,
    zoom: initialZoom,
    mapId: 'd417de3b2160e536ca76c676'
  });
  mapDiv.classList.add('map-initialized');

  map.addListener('click', () => {
    if (currentInfoWindow) {
      currentInfoWindow.close();
      currentInfoWindow = null;
    }
  });

  displayMarkersOnMap(allFlowerSpotsData);

  const filterForm = document.getElementById('filter-form');
  if (filterForm) {
    if (!filterForm.dataset.listenerAttached) {
        filterForm.addEventListener('change', applyFiltersAndRedrawMarkers);
        filterForm.dataset.listenerAttached = 'true';
    }
  }
}

document.addEventListener("turbo:load", function() {
  if (document.getElementById('map')) {
    initializeHanamap();
  }
});
