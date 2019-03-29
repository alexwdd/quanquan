<template>
    <googlemaps-map
    :center.sync="center"
    :zoom.sync="zoom"
    :options="mapOptions"
    @idle="onIdle"
    @click="onMapClick">

    <googlemaps-marker
    v-for="marker of markers"
    :key="marker._id"
    :label="{
      color:'#f00',
      fontFamily: 'Material Icons',
      fontSize: '20px',
      text: 'star_rate',
    }"
    :position="marker.position"
    icon="/static/image/map.png"
    @click="selectMarker(marker._id)"
  />
    </googlemaps-map>
</template>

<script>
import Vue from "vue";
import 'vue-googlemaps/dist/vue-googlemaps.css'
import VueGoogleMaps from 'vue-googlemaps'

Vue.use(VueGoogleMaps, {
  load: {
    // Google API key
    apiKey: 'AIzaSyD6569ST34pV9m3ECxVXSakk8tz760nfAk',
    // Enable more Google Maps libraries here
    libraries: ['places'],
    // Use new renderer
    useBetaRenderer: false,
  },
})
export default {
    data() {
        return {
            center: { lat: 10.0, lng: 10.0 },
            zoom : 7,
            markers: [
                {
                    position: { lat: 10.0, lng: 10.0 }
                },
                {
                    position: { lat: 11.0, lng: 11.0 }
                }
            ]
        };
    }
};
</script>

<style>
</style>
