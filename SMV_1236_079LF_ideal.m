%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Esta funcion guarda todo lo necesario sobre el SMV-1236-079LF en su
    versión ideal, sin parásitos.

%}

function [Zvar, CJ, CT] = SMV_1236_079LF_ideal (VR, f)

    % Variables
    j = 1i;
    w = 2*pi*f;
    % se utiliza 10e-30 en lugar de 0 para evitar problemas computacionales
    C_parasita = 10e-30;   % [F]
    L_parasita = 10e-30;   % [H]
    R_parasita = 10e-30;   % [ohm]

    CJO = 22.89*10^-12; 
    VJ = 9.62; 
    M = 5.23; 
    CJ = CJO./((1+(VR./VJ)).^M);
    CT = CJ + C_parasita;
    
    Z_CJ = 1 ./ (j * w * CJ);
    Z_C_parasita = 1 ./ (j * w * C_parasita);
    Z_L_parasita = j * w * L_parasita;

    % Impedancia del varactor
    Zvar = (Z_L_parasita + (((Z_CJ + R_parasita) .* Z_C_parasita) ./ (Z_CJ + R_parasita + Z_C_parasita)));
    
    %{
    % Visualizar capacidades del varactor en función del voltaje
    figure('Name', 'Curvas de Capacidad del Varactor', 'NumberTitle', 'off');
    plot(VR, CJ*1e12);
    hold on;
    plot(VR, CT*1e12);
    hold off;
    grid on;
    xlabel('V_R [V]');
    ylabel('Capacidad [pF]');
    title('Comportamiento de C_J y C_T vs Voltaje inverso');
    legend('C_J', 'C_T');
    %}
end