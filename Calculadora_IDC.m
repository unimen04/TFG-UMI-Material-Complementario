%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Código utilizado para, mediante una interfaz gráfica, poder variar los
    diferentes parámetros que conforman un condensador IDC, devolviendo la
    capacidad que tendrá dicho IDC. 

    Éste código ha sido desarrollado con ayuda de Google Gemini 3.1 Pro.

%}


function Calculadora_IDC()
    % 1. Crear la ventana principal (UI Figure)
    fig = uifigure('Name', 'Calculadora IDC', 'Position', [500 150 520 580]);
    
    % 2. Crear los componentes visuales
    % --- Constante Dieléctrica (er) ---
    uilabel(fig, 'Text', 'Constante Dieléctrica del Sustrato (er):', 'Position', [50 510 350 22]);
    sliderEr = uislider(fig, 'Position', [50 470 280 3], 'Limits', [1 15], 'Value', 3.5);
    editEr   = uieditfield(fig, 'numeric', 'Position', [360 475 90 22], 'Value', 3.5, 'Limits', [1 15]);
    
    % --- Número de dedos (N) ---
    uilabel(fig, 'Text', 'Número de dedos (N):', 'Position', [50 415 350 22]);
    sliderN = uislider(fig, 'Position', [50 375 280 3], 'Limits', [2 30], 'Value', 6);
    editN   = uieditfield(fig, 'numeric', 'Position', [360 380 90 22], 'Value', 6, 'Limits', [2 30], 'RoundFractionalValues', 'on');
    
    % --- Longitud del dedo (L) en mm ---
    uilabel(fig, 'Text', 'Longitud de dedos (L) en mm:', 'Position', [50 320 350 22]);
    sliderL = uislider(fig, 'Position', [50 280 280 3], 'Limits', [0.1 10], 'Value', 2.2);
    editL   = uieditfield(fig, 'numeric', 'Position', [360 285 90 22], 'Value', 2.2, 'Limits', [0.1 10]);
    
    % --- Ancho del dedo (W) en mm ---
    uilabel(fig, 'Text', 'Ancho de dedos (W) en mm:', 'Position', [50 225 350 22]);
    sliderW = uislider(fig, 'Position', [50 185 280 3], 'Limits', [0.05 2], 'Value', 0.2);
    editW   = uieditfield(fig, 'numeric', 'Position', [360 190 90 22], 'Value', 0.2, 'Limits', [0.05 2]);
    
    % --- Separación entre dedos (S) en mm ---
    uilabel(fig, 'Text', 'Separación entre dedos (S) en mm:', 'Position', [50 130 350 22]);
    sliderS = uislider(fig, 'Position', [50 90 280 3], 'Limits', [0.05 2], 'Value', 0.15);
    editS   = uieditfield(fig, 'numeric', 'Position', [360 95 90 22], 'Value', 0.15, 'Limits', [0.05 2]);
    
    % --- Etiqueta de Resultado ---
    lblResultado = uilabel(fig, 'Text', 'Capacidad: 0.1292 pF', ...
                          'Position', [50 25 400 40], ...
                          'FontSize', 22, 'FontWeight', 'bold', 'FontColor', [0 0.45 0.74]);
                          
    % 3. Configurar sincronización bidireccional y cálculo
    sliderEr.ValueChangingFcn = @(src, event) actualizarDesdeSlider(editEr, event.Value);
    sliderN.ValueChangingFcn  = @(src, event) actualizarDesdeSlider(editN, round(event.Value));
    sliderL.ValueChangingFcn  = @(src, event) actualizarDesdeSlider(editL, event.Value);
    sliderW.ValueChangingFcn  = @(src, event) actualizarDesdeSlider(editW, event.Value);
    sliderS.ValueChangingFcn  = @(src, event) actualizarDesdeSlider(editS, event.Value);
    
    sliderN.ValueChangedFcn   = @(src, event) finalSyncN(sliderN, editN);
    editEr.ValueChangedFcn = @(src, event) actualizarDesdeEdit(sliderEr, src.Value);
    editN.ValueChangedFcn  = @(src, event) actualizarDesdeEditN(sliderN, editN);
    editL.ValueChangedFcn  = @(src, event) actualizarDesdeEdit(sliderL, src.Value);
    editW.ValueChangedFcn  = @(src, event) actualizarDesdeEdit(sliderW, src.Value);
    editS.ValueChangedFcn  = @(src, event) actualizarDesdeEdit(sliderS, src.Value);
    
    % =====================================================================
    % FUNCIONES DE LOGICA INTERNA
    % =====================================================================
    function actualizarDesdeSlider(editCtrl, val)
        editCtrl.Value = val;
        calcular_y_mostrar();
    end
    
    function actualizarDesdeEdit(sliderCtrl, val)
        sliderCtrl.Value = val;
        calcular_y_mostrar();
    end
    
    function actualizarDesdeEditN(sliderCtrl, editCtrl)
        val = round(editCtrl.Value);
        editCtrl.Value = val;
        sliderCtrl.Value = val;
        calcular_y_mostrar();
    end
    
    function finalSyncN(sliderCtrl, editCtrl)
        val = round(sliderCtrl.Value);
        sliderCtrl.Value = val;
        editCtrl.Value = val;
        calcular_y_mostrar();
    end
    
    function calcular_y_mostrar()
        er_val = editEr.Value;
        N    = editN.Value;
        L_m  = editL.Value * 1e-3;
        W_mm = editW.Value;
        S_mm = editS.Value;
        
        e0 = 8.854e-12;
        ere = (er_val + 1) / 2;
        
        k0 = S_mm / (S_mm + 2 * W_mm);
        k0_prime = sqrt(1 - k0^2);
        
        if k0 <= 0.707
            ratio = pi / log(2 * (1 + sqrt(k0_prime)) / (1 - sqrt(k0_prime)));
        else
            ratio = (1 / pi) * log(2 * (1 + sqrt(k0)) / (1 - sqrt(k0)));
        end
        
        C_F = (N - 1) * L_m * e0 * ere * ratio;
        C_pF = C_F * 1e12;
        
        lblResultado.Text = sprintf('Capacidad: %.4f pF', C_pF);
    end
end