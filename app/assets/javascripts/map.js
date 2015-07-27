
 /////////////////////////////////////////// Obtener info desde modelo /tracks/id/points.json /////////////////////////////////////////

  $.getJSON('/tracks/' + gon.track_number.id + '/points.json', function (data){

  Radio_tierra = 6371;                                 // Radio de la Tierra 
  limite_velocidad = 40;

	elemento = data;                                     // Info desde API latlng
  largo = elemento.length;                             // Cantidad de info de la API latlng                    
	x  = new Array(elemento.length);                     // Arreglo GPS bruto 
	t  = new Array(elemento.length);                     // Arreglo de tiempo bruto
  t1 = new Array(elemento.length);                     // Arreglo de tiempo depurado
  xf = new Array(1);                                   // Arreglo GPS depurado


  for (var i = 0; i < elemento.length; i++) {
      x[i] = elemento[i].latlng;
  }

///////////////////////////////////// Ordenar el arreglo CSV por fecha, en caso de venir desordenado ////////////////////////////////////

  for (var i = 0; i < elemento.length; i++) {         // Obtengo elemento tiempo
      t[i] = elemento[i].tiempo;
  }


  t1[0] = t[0];                                       // Inicializacion de fecha -- Cambiar a t[length-1] para subir a heroku
  
  for (var i = 0; i < t.length-1; i++) {  
    if (t[i] < t1[0]){ 
      t1[0] = t[i];
    }
  }

  t1[1] = "2020-20-01T20:00:00.000Z";                  // Fecha de Orden mayor virtualmente infinito
  for (var i = 0; i < t.length-1; i++) {               // Revision del vector t original
      for(var j = 0; j < t.length; j++){               // Revision de vector t1, modificado
          if(t[i] > t1[j]   &   t[i] < t1[j+1]) {
    
              for(var k = t.length-1; k >= j; k--){    // Correr vector desde pos i+1 a la i+2
                t1[k+1]=t1[k];
                xf[k+1]=xf[k];
              }
              t1[j+1] = t[i]
              xf[j+1] = x[i];
              break;              
          }}}

 xf = xf.filter(function(n){ return n != undefined });  // Eliminar elementos nulos
 t1 = t1.filter(function(n){ return n != undefined });  // Eliminar elementos nulos

///////////////////////////////// Obtener Vector Velocidad ///////////////////////////////////////////////////

 largo_velocidad = xf.length - 1;
 v      = new Array(largo_velocidad);
 t_s    = new Array(largo_velocidad);
 info_v = new Array(largo_velocidad - 1);

 for (var i = 0; i < largo_velocidad; i++) {   
    lat0  = parseFloat(xf[i][0]);
    lat1  = parseFloat(xf[i+1][0]);
    lon0  = parseFloat(xf[i][1]);
    lon1  = parseFloat(xf[i+1][1]);
    dx    = Math.sqrt(Math.pow((lat0 - lat1),2) + Math.pow((lon0 - lon1),2))*Radio_tierra*2*3.1415*0.6/360; // Delta entre coords
    t_0d  = new Date(t1[i]);
    t_1d  = new Date(t1[i+1]);
    t_0   = t_0d.getHours()*3600 + t_0d.getMinutes()*60 + t_0d.getSeconds();
    t_s[i]= t_0;
    t_1   = t_1d.getHours()*3600 + t_1d.getMinutes()*60 + t_1d.getSeconds();
    dt    = Math.abs(t_0 - t_1)/3600;
    v[i]  = (dx/dt).toFixed(2);
    if (v[i] >= limite_velocidad){
      v[i] = null;
    }
 }

 for (var i = 0; i < info_v.length; i++) {            // Arreglo de elementos para graficar morris.js
    info_v[i] = { time: t1[i], speed: v[i] };
 }


///////////////////////////////// Calculo de Centroide del Mapa ////////////////////////////////////////// 
////

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
//  L.control.fullscreen().addTo(map);            // Opcion de pantalla completa
  L.polyline(xf, polyline_options).addTo(map);


/////////////////////////////////////// Dibujar Linea y Marcadores de Origen Destino ////////////////////////////////////////////


  L.mapbox.featureLayer({
    type: 'Feature',
    geometry: {
        type: 'Point',
        coordinates: [
          xf[0][1],                               // En GeoJSON se ocupa longitud en primer lugar 
          xf[0][0]                                // latitud en segundo lugar
        ]
    },
    properties: {
        title: 'Origen',                         // Para darle distintos estilos al marcador ir a 
        'marker-size': 'medium',                 // https://www.mapbox.com/guides/an-open-platform/#simplestyle
        'marker-color': '#3885d4',
        'marker-symbol': 'building'
    }
  }).addTo(map);


    L.mapbox.featureLayer({
    type: 'Feature',
    geometry: {
        type: 'Point',
        coordinates: [
          xf[xf.length - 1][1],                               // En GeoJSON se ocupa longitud en primer lugar 
          xf[xf.length - 1][0]                                // latitud en segundo lugar
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
    tiempo_segundos =  Math.abs(horas_f*3600 + minutos_f*60 + segundos_f - horas_0*3600 - minutos_0*60 - segundos_0);   // tiempo_segundos: tiempo total en segundos
    horas_total     =  Math.floor(tiempo_segundos / 3600)                                                               // horas_total: Parte entera del tiempo total en horas
    minutos_total   =  Math.floor((tiempo_segundos - horas_total*3600)/60)                                              // minutos_total: Parte entera del tiempo total en minutos
    segundos_total  =  Math.floor(tiempo_segundos - minutos_total*60 - horas_total*3600)                                // segundos_total: Parte entera del tiempo total en segundos
  }


////////////////////// Calculo de distancia Recorrida y Velocidad Media /////////////////////////////////////////////////////////////////
////////////////////// Huella de Carbono

  var polylinea = {                                     // Linea en formato GeoJSON 
    "type": "Feature",                                  // Necesaria para ocupar Libreria turf 
    "properties": {},
    "geometry": {
      "type": "LineString",
      "coordinates": xf
    }
  };


  var distancia_HTML = document.getElementById('distancia');
  var tiempo_HTML    = document.getElementById('tiempo');
  var velocidad_HTML = document.getElementById('velocidad');
  var aporte_HTML    = document.getElementById('aporte');


  length = turf.lineDistance(polylinea, 'kilometers');  // Determina el largo del recorrido

  velocidad = parseInt(length)*3600/Math.abs(tiempo_segundos);    // Determina velocidad en km/hr

  CO2 = parseInt(length)*0.9

  distancia_HTML.innerHTML = length.toFixed(2) + ' km';
  tiempo_HTML.innerHTML = horas_total + ':' + minutos_total + ':' + segundos_total;
  velocidad_HTML.innerHTML  = velocidad.toFixed(2) + ' km/hr';
  aporte_HTML.innerHTML  = CO2.toFixed(2) + ' kg CO2 ahorrados';

//////////////////////////////// Interaccion con Mapa ////////////////////////////////////////////////////

  var marker =  L.marker([0, 0], {     // Marcador viajero
  icon: L.mapbox.marker.icon({
    'marker-size': 'medium',                 // https://www.mapbox.com/guides/an-open-platform/#simplestyle
    'marker-color': '#3885d4',
    'marker-symbol': 'bicycle'
  })
}).addTo(map);

////////////////////////////// Tablas de Estadisticas /////////////////////////////////////////////////////

new Morris.Line({
  element: 'info',                    // ID of the element in which to draw the chart.
  data: info_v,                       // Arreglo con la informacion a mostrar
  xkey: ['time'],                     // Eje X
  ykeys: ['speed'],                   // eje Y
  labels: ['Velocidad [km/hr]'],      // Titulos de Ejes
  continuousLine: 'true',
  pointSize: 0,
  }).on("click", function(i){
      marker.setLatLng(L.latLng(xf[i][0],xf[i][1]));          // Mostrar marcador
      console.log(i)
  });



});