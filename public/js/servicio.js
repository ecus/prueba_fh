jQuery(function($) {
    var oTable;
    var horarios=[];
    var giRedraw = false;
    var fila=1;
    var auxId;
        $("#frmServicio").validate({
            debug: true,
            rules: {
                        txtNombre: {
                            required: true,
                            minlength:3,
                            maxlength:45,
                        },
                        dtpFecha: {
                            required: true,
                        },
                        // txtMonto: {
                        //     required: true,
                        //     maxlength:6,
                        // },
                        // txtTipo: {
                        //     digits: true,
                        //     minlength:3
                        // },
                        // txtdiasCupon: {
                        //     digits: true
                        // },
                        // txtfreezing: {
                        //     digits: true
                        // },
                        // txtMontoIni: {
                        //     digits:true,
                        // },
                        lstSucursal: {
                            required: true
                        },
                    },
            messages:{
                        txtNombre:{
                            required: '<span class="label label-warning">Campo Obligatorio</span>'
                        },
                        dtpFecha: {
                            required: '<span class="label label-warning">Campo Obligatorio</span>'
                        },

                        // txtMonto:{
                        //     required: '<span class="label label-warning">Campo Obligatorio</span>'
                        // },
                        // txtTipo :{
                        //     digits: '<span class="label label-warning">Solo numeros</span>',
                        //     minlength: '<span class="label label-warning">minimo 3 caracteres</span>'
                        // },
                        // txtdiasCupon :{
                        //     digits: '<span class="label label-warning">Solo numeros</span>',
                        // },
                        // txtfreezing :{
                        //     digits: '<span class="label label-warning">Solo numeros</span>',
                        // },
                        lstSucursal:{
                            required: '<span class="label label-warning">Debe Elegir al Menos Una sucursal.</span>'
                        },
                    },
        });

/*        $('#btnRegServicio').on('click',function(event){
            if ($(frmServicio).valid()){
                if (horarios.length==0)
                {
                    $('#modalAccion').modal('show');
                }else{
                    $('#btnRegistrar').click();
                }
            }
        });*/

        $('#cmbSucursal').on('change',function(event){
            if ($(lstSucursal).val()==null) {
                $(cmbSucursal).prop('selectedIndex',0);
                $("#msjeModal").empty().html('No seleciono ninguna sucursal en el grupo de sucursales que contaran con este servicio.');
                $("#modalServicio").modal();
            } else{
                if (jQuery.inArray($(this).val(), $(lstSucursal).val())==-1){
                    $(cmbSucursal).prop('selectedIndex',0);
                    $("#msjeModal").empty().html('La sucursal elegida no se encuentra en el grupo de sucursales que contaran con este servicio.');
                    $("#modalServicio").modal();
                };
            };
        });
        $('#btnCancelar').on('click',function(event){
            // console.log($(lstSucursal).val());
            limpiaControlesBasico();
            /*var fecha = new Date;
            $(dtpFecha).val(fecha.getDate());*/
        });
        $('#btnRegServicio').on('click',function(event){
            var accion = $('#btnRegServicio').attr('value');
            $('#modalAccion').modal('hide');
            if (accion=='Registrar'){
                if ($("#frmServicio").valid()) {
                    $.post("regservicio",{
                        /*
                        $.post("pruebas",{
                        txtMonto        :$(txtMonto).val(),
                        txtdiasCupon    :$(txtdiasCupon).val(),
                        txtfreezing     :$(txtfreezing).val(),
                        txtMontoIni     :$(txtMontoIni).val(),
                        horario         :horarios*/
                        txtNombre       :$(txtNombre).val(),
                        dtpFecha        :$(dtpFecha).val(),
                        cmbEmpresa      :($(cmbEmpresa).val())?$(cmbEmpresa).val():null,
                        lstSucursal     :$(lstSucursal).val(),
                        txtTipo         :$(txtTipo).val(),
                        txtPersonal     :$(txtPersonal).val()
                    }, function(data) {
                        if (data.response == false){
                            $("#msjeModal").empty().html("Ocurrió un error en el registro del servicio.");
                            $("#modalServicio").modal();
                        }else{
                            $("#msjeModal").empty().html(data.response);
                            $("#modalServicio").modal();
                            $('#btnCancelar').click();
                        }
                    },'json');
                }else{
                    $('#modalAccion').modal('hide');
                };
            }
        });

        $('#btnConfirmar').on('click',function(event){
            var msje         =  addHorario('boxDia1');
            var aux      =  0;
            var mostrar;

            if (msje){
                    var cant=0;
                    mostrar = '<p>';
                    $.each(msje,function(clave,valor) {
                        cant    +=  1;
                        mostrar =   mostrar + valor + '<br/>';
                        if (cant==2){
                            mostrar =   mostrar + '<br/>';
                            cant=0;
                        };
                    });
                    mostrar = mostrar + '</p>';
                    $('#msjeModal').empty().append(mostrar);
                    $('#modalServicio').modal('show');
            }else{
                    var cont=1;
                    var aux=1;
                    var sw=0;
                    $('#boxContenido').empty();
                    var diasSemana = new Array();
                    diasSemana['L'] = "Lunes";
                    diasSemana['M'] = "Martes";
                    diasSemana['W'] = "Miercoles";
                    diasSemana['J'] = "Jueves";
                    diasSemana['V'] = "Viernes";
                    diasSemana['S'] = "Sabado";
                    diasSemana['D'] = "Domingo";
                    // console.log(horarios.length);
                    $.each(horarios,function() {
                        var texto='';
                        // console.debug($(this)[0]);
                        texto="Sucursal: "+$('#cmbSucursal option[value="'+$(this)[0]['sucursal']+'"]').html()+"<br>";
                        texto=texto+"Trainer: "+$('#cmbEncargado option[value="'+$(this)[0]['personal']+'"]').html()+"<br>";
                        $.each($(this)[0]['detalle'],function(){
                            var dia=$(this)[0]['dia'];
                            // console.log(diasSemana[dia.toString()]);
                            texto=texto+diasSemana[dia] + ": "+ $(this)[0]['ini'] + " - " + $(this)[0]['fin'] +"<br>";
                        });
                        if (cont==1){
                            if (sw==0) {
                                $('#boxContenido').append('<div class="col-12" id="boxHorario'+aux+'"><div class="color4 col-6">'+texto+'</div></div>');
                            } else{
                                $('#boxContenido').append('<br /><div class="col-12" id="boxHorario'+aux+'"><div class="color4 col-6">'+texto+'</div></div>');
                            };
                            cont+=1;

                        }else{
                            $('#boxHorario'+aux).append('<div class="hero-unit color4 col-6">'+texto+'</div>');
                            cont=1;
                            aux+=1;
                        };
                    });
            };
        });

        function addHorario(id){
            var dias    = [];
            var mensaje = [];
            var sw      = 0;
            var sel     = 0;
            $(':checkbox:checked').each(function() {
                var x    = 0;
                var c    = $(this).attr('class');
                var hini = $("#"+c+"Ini").val();
                var hfin = $("#"+c+"Fin").val();
                if (hini != "" && hfin != "") {
                    if (hini==hfin){
                        sw  =   1;
                        mensaje.push('Hora de Inicio y fin del dia <b>'+ c + '</b> no deben ser iguales.');
                    }else{
                        if (hini>hfin){
                            sw  =   1;
                            mensaje.push('Hora de Inicio del dia <b>'+ c +'</b> no puede ser mayor a Hora de Fin.');
                        }else{
                            dias.push({
                                dia:$(this).val(),
                                ini:hini,
                                fin:hfin
                            });
                            sw=2;
                        };
                    };
                } else{
                    sw  =   1;
                    if (hini==""){ mensaje.push('Falta Ingresar Hora de Inicio del dia <b>'+c+'</b>'); };
                    if (hfin==""){ mensaje.push('Falta Ingresar Hora de Fin del dia <b>'+c+'</b>'); };
                };
                sel     =   1;
            });
            if(sel==0){
                mensaje.push('Debe elegir sucursal');
                return mensaje;
            }else{
                if(sw==2){
                    var per     =   $('#'+ id +' #cmbEncargado').val();
                    var suc     =   $('#'+ id +' #cmbSucursal').val();
                    if (per.length >0 && suc.length >0) {
                        if (horarios.length==0) {
                            horarios.push({
                                    personal: per,
                                    sucursal: suc,
                                    detalle:dias
                                });
                            x=1;
                        }else{
                            $.each(horarios, function(index,val) {
                                    // console.debug(val);
                                    // console.debug({personal: per,sucursal: suc,detalle:dias});
                                // if(val=={personal: per,sucursal: suc,detalle:dias}){
                                if(JSON.stringify(val)==JSON.stringify({personal: per,sucursal: suc,detalle:dias})){
                                    mensaje.push('horario ingresado antes. Por favor verifique los datos.');
                                }else{
                                        horarios.push({
                                            personal: per,
                                            sucursal: suc,
                                            detalle:dias
                                        });
                                };
                                console.debug(val);
                            });
                            if (mensaje.length>0) {
                                return mensaje;
                            };
                        };
                    } else{
                        if (per.length < 1){ mensaje.push('Debe elegir personal'); };
                        if (suc.length < 1){ mensaje.push('Debe elegir sucursal'); };
                        return mensaje;
                    };
                } else{
                    return mensaje;
                };
            };
        };

});