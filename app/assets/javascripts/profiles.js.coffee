# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateMarkers = ->
  $.ajax
    dataType: 'text'
    url: 'profiles.json'
    success: (data) ->
      coordinates = JSON.parse(data)
      for point in coordinates
        L.marker([point['lat'], point['lng'] ]).addTo(index_map)

window['updateMarkers'] = updateMarkers