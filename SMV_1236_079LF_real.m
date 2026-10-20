%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Esta funcion guarda todo lo necesario sobre el SMV-1236-079LF en su
    versión real, con parásitos.

%}


function [Zvar, CJ, CT] = SMV_1236_079LF_real (VR, f)

    % Variables
    j = 1i;
    w = 2*pi*f;
    C_parasita = 3.59e-12;      % [F]
    L_parasita = (0.7)*1e-9;    % [H]
    R_parasita = 0.5;           % [ohm]
    L_via = 1.3*1e-9;

    CJO = 22.89*10^-12; 
    VJ = 9.62; 
    M = 5.23; 
    CJ = CJO./((1+(VR./VJ)).^M);
    CT = CJ + C_parasita;
    
    Z_CJ = 1 ./ (j * w * CJ);
    Z_C_parasita = 1 ./ (j * w * C_parasita);
    Z_L_parasita = j * w * L_parasita;
    Z_L_via = 0; %si se desea incluir el efecto de la vía: Z_L_via = j * w * L_via;

    % Impedancia del varactor
    Zvar = Z_L_via + (Z_L_parasita + (((Z_CJ + R_parasita) .* Z_C_parasita) ./ (Z_CJ + R_parasita + Z_C_parasita)));
    
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