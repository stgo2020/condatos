$(function () {
    $.getJSON('/tracks.json', function (data) {

        informacion   = data;
        arreglo_data  = new Array(numero_elementos);

        for (var i = 0; i < fecha.length; i++) {           // filtro la lista para saber que tracks corresponden a la id del usuario
            arreglo_data[i] = new Array(4);                // Transformar cada arreglo en un subarreglo de 3 elementos 
            date = fecha[i];
            dsplit = date.split("-");
            d = new Date(dsplit[0],dsplit[1]-1,dsplit[2]); // pasar de fecha a millisegundos desde 1970
            arreglo_data[i][0] = d.getTime();
            arreglo_data[i][1] = distancia[i];
            arreglo_data[i][2] = velocidad[i];
            arreglo_data[i][3] = track_id[i];   
        }


        // create the chart
        $('#container').highcharts('StockChart', {
            chart: {
                alignTicks: false
            },

            rangeSelector: {
                allButtonsEnabled: true,
                selected: 2
            },

            plotOptions: {
                series:  {
                    cursor: 'pointer',
                    point: {
                        events: {
                            click: function () {
                                
                                param_y = this.y;
                                param_x = this.x;

                                for (var i = 0; i < fecha.length; i++) {           // Loop para identificar id del punto y redirigir al sitio 
                                    if (arreglo_data[i][0] == param_x && distancia[i]== param_y){
                                        url = 'http://192.168.1.20:3000/tracks/' + track_id[i];
                                        window.location.replace(url);
                                        break;
                                        }
                                    }
                            }
                        }
                    }
                }
            },


            title: {
                text: 'Mis Recorridos'
            },

            tooltip: {
                valueSuffix: 'Km'
            },

            series: [{
                type: 'column',
                name: 'Distancia Recorrida',
                data: arreglo_data,
                
            }]
        });
    });





});