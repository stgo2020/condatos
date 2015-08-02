$(function () {$.getJSON('/tracks.json', function (data) {


        $('#container').highcharts({

             plotOptions: {
                crosshairs: true,
             series: {
                point: {
                    events: {
                        mouseOver: function () {
                            var chart = this.series.chart;
                            vel = this.y;
                            tie = this.x;
                            for (var i = 0; i < info_v.length; i++) {           // Loop para identificar id del punto y redirigir al sitio 
                                if (info_v[i][1] == vel && info_v[i][0]== tie){          
                                    marker.setLatLng([xf[i][0],xf[i][1]])
                                    marker.addTo(map);
                                    break;
                                    }
                                }   
                            }
                        }
                    },
                    events: {
                        mouseOut: function () {
                            }
                       }
                    }
                },
            chart: {
                zoomType: 'x',
            },
            title: {
                text: ' '
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                min: 0,
                max: 40,
            },
            legend: {
                enabled: false
            },
            series: [{
                name: 'Velocidad [Km/hr]',
                data: info_v,
                type: 'area',
            }]
        });
    });
});

