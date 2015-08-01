$.getJSON('/tracks.json', function (data){

id = gon.user_number
elemento = data
numero_elementos = 0;
tiempo_total     = 0;
distancia_total  = 0;


for (var i = 0; i < elemento.length; i++) {  // filtro la lista para saber que tracks corresponden a la id del usuario
    if(elemento[i].props[0]==id){            // En otras palabras ... filtrar los recorridos que son mios 
    	numero_elementos++;
    }
}
 
fecha     = new Array(numero_elementos); 
tiempo    = new Array(numero_elementos);
velocidad = new Array(numero_elementos);
distancia = new Array(numero_elementos);
contador = 0;

for (var i = 0; i < elemento.length; i++) {
    if(elemento[i].props[0]==id){
    	fecha[contador]     = elemento[i].props[1];
		tiempo[contador]    = elemento[i].props[2]; 
		velocidad[contador] = elemento[i].props[3]; 
		distancia[contador] = elemento[i].props[4]; 
    	contador++;
    }
}

///////////////////////////// Obtengo tiempo Actual //////////////////////////////////////////////////////////////////

currentdate = new Date(); 
weekday = new Array(7);
weekday[0]=  "Domingo";
weekday[1] = "Lunes";
weekday[2] = "Martes";
weekday[3] = "Miércoles";
weekday[4] = "Jueves";
weekday[5] = "Viernes";
weekday[6] = "Sábado";
dia = weekday[currentdate.getDay()];

datetime =         dia + ", "  
                + currentdate.getHours() + ":"  
                + currentdate.getMinutes() + ":" 
                + currentdate.getSeconds();


///////////////////////////// Obtengo estadisticas totales ///////////////////////////////////////////////////////////

for (var i = 0; i < contador ; i++) {
		distancia_total = distancia_total + distancia[i];  
		tiempo_total    = tiempo_total    + tiempo[i];
}
    horas_total     =  Math.floor(tiempo_total / 3600)                                                               // horas_total: Parte entera del tiempo total en horas
    minutos_total   =  Math.floor((tiempo_total - horas_total*3600)/60)                                              // minutos_total: Parte entera del tiempo total en minutos
    segundos_total  =  Math.floor(tiempo_total - minutos_total*60 - horas_total*3600) 


  fecha_HTML       = document.getElementById('fecha');
  tiempo_HTML      = document.getElementById('tiempo_t');
  distancia_HTML   = document.getElementById('distancia_t');
  fecha_HTML.innerHTML     = datetime;
  distancia_HTML.innerHTML = distancia_total.toFixed(2) + ' Km';
  tiempo_HTML.innerHTML    = horas_total + ':' + minutos_total + ':' + segundos_total + ' hrs';




});