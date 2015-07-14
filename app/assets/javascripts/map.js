
 /////////////////////////////////////////// Obtener info desde modelo /tracks/id/points.json /////////////////////////////////////////

  $.getJSON('/tracks/' + gon.track_number.id + '/points.json', function (data){
	elemento = data;
	x = new Array(elemento.length);                     // Arreglo x mantiene todas las coordenadas del metodo latlng 
	
  for (var i = 0; i < elemento.length; i++) {
   		x[i] = elemento[i].latlng;
	}

///////////////////////////////// Calculo de Centroide del Mapa //////////////////////////////////////////////

  lat_max = x[0][0];                                  // inicializar variables
  lat_min = x[0][0];
  lon_max = x[0][1];
  lon_min = x[0][1];

  for (var j = 0; j < x.length; j++) {                // metodo para obtener los extremos de la ruta
      latitud  = x[j][0];                             // latitud  iniciales
      longitud = x[j][1];                             // longitud iniciales
      if (lat_max < latitud){                          
          lat_max = latitud;
      }
      if (lat_min > latitud){ 
          lat_min = latitud;
      }
      if (lon_max < longitud){ 
          lon_max = longitud;
      }
      if (lon_min > longitud){ 
        lon_min = longitud;
      }
  }

  lat_center = (lat_max + lat_min)/2;                   // calculo del centroide de la ruta
  lon_center = (lon_max + lon_min)/2;  
  
  L.mapbox.accessToken = 'pk.eyJ1Ijoic3RnbzIwMjAiLCJhIjoiNWsxUk9SbyJ9.vm-DGjtV90O2SPz_MaLQNQ';

  var map = L.mapbox.map('map', 'mapbox.streets')
    .setView([lat_center, lon_center], 12);

  var polyline = L.polyline(x, polyline_options).addTo(map);

  L.mapbox.featureLayer({
    type: 'Feature',
    geometry: {
        type: 'Point',
        coordinates: [
          x[0][1],                               // En GeoJSON se ocupa longitud en primer lugar 
          x[0][0]                                // latitud en segundo lugar
        ]
    },
    properties: {
        title: 'Origen',                      // Para darle distintos estilos al marcador ir a 
        'marker-size': 'medium',                 // https://www.mapbox.com/guides/an-open-platform/#simplestyle
        'marker-color': '#3885d4',
        'marker-symbol': 'bicycle'
    }
  }).addTo(map);


/////////////////////////////////////// Dibujar Linea y Marcadores de Origen Destino ////////////////////////////////////////////

    L.mapbox.featureLayer({
    type: 'Feature',
    geometry: {
        type: 'Point',
        coordinates: [
          x[x.length - 1][1],                               // En GeoJSON se ocupa longitud en primer lugar 
          x[x.length - 1][0]                                // latitud en segundo lugar
        ]
    },
    properties: {
        title: 'Destino',
        'marker-size': 'medium',           
        'marker-color': '#3885d4',
        'marker-symbol': 'embassy'
    }
  }).addTo(map);


//////////////////////////////////////////// Calculo de Tiempo Total ///////////////////////////////////////////////////////////////////

  t_0 = elemento[0].tiempo;                           // Estas definiciones permiten obtener el tiempo
  t_f   = elemento[elemento.length - 1].tiempo;       // entre el primer registro y el ultimo 
  fecha_0 = t_0.split('T');                           // se debe hacer parse a un string del tipo
  fecha_f = t_f.split('T');                           // YYYY-MM-DDTHH:MM:SS.DDDZ
  hora_0  = fecha_0[1];                               // Yikes!
  hora_f  = fecha_f[1];
  segundos_0 = parseInt(hora_0.substring(6,8));
  minutos_0  = parseInt(hora_0.substring(3,5));
  horas_0    = parseInt(hora_0.substring(0,2));
  segundos_f = parseInt(hora_f.substring(6,8));
  minutos_f  = parseInt(hora_f.substring(3,5));
  horas_f    = parseInt(hora_f.substring(0,2));
  fecha_0 = fecha_0[0];
  fecha_f = fecha_f[0];
  if (fecha_0 == fecha_f){                            // En el caso de que el tiempo transcurra en el mismo dia
    tiempo_segundos =  horas_f*3600 + minutos_f*60 + segundos_f - horas_0*3600 - minutos_0*60 - segundos_0;   // tiempo_segundos: tiempo total en segundos
    horas_total     =  Math.floor(tiempo_segundos / 3600)                                                     // horas_total: Parte entera del tiempo total en horas
    minutos_total   =  Math.floor((tiempo_segundos - horas_total*3600)/60)                                    // minutos_total: Parte entera del tiempo total en minutos
    segundos_total  =  Math.floor(tiempo_segundos - minutos_total*60 - horas_total*3600)                      // segundos_total: Parte entera del tiempo total en segundos
  }


////////////////////// Calculo de distancia Recorrida y Velocidad Media /////////////////////////////////////

  var polylinea = {                                     // Linea en formato GeoJSON 
    "type": "Feature",                                  // Necesaria para ocupar Libreria turf 
    "properties": {},
    "geometry": {
      "type": "LineString",
      "coordinates": x
    }
  };

  var count = document.getElementById('count');
  length = turf.lineDistance(polylinea, 'kilometers');  // Determina el largo del recorrido

  velocidad = parseInt(length)*3600/Math.abs(tiempo_segundos);    // Determina velocidad en km/hr
  count.innerHTML = '<label>Distancia Total</label>' + length.toFixed(2) + ' km' + '<br><br><label>Tiempo Total</label>' + horas_total + ':' + minutos_total + ':' + segundos_total + '<br><br><label>Velocidad Promedio</label>' + velocidad.toFixed(2) + ' km/hora';


	});