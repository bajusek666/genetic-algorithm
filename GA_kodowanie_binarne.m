
% Algortym genetyczny

% Inicjaliacja parametrów 

m = 16; % Liczba osobników
sub_genomes = [10,10]; % Długość poszczególnych podciągów (kolejnych zmiennych reprezentowanych przez genom)
l = sum(sub_genomes);
pc = 0.7; % prawdopodobieństwo krzyżowania
pm = 0.01; % Prawdopodobieństwo mutacji bitu
lg = 100; % Liczba generacji
a = 0;
b = 10;

% Funckje przystosowania
fit_fun = @(x) x + sin(3 + cos(5 * x)) + 0.8;
fit_fun_2 = @(x1,x2) ((25 - (x1 - 5)^2 ) * cos(2 * (x1 - 5))) + ((25 - (x2 - 5)^2) * cos(2 * (x2 - 5))) + 50;
fit_fun_2_m = @(M) ((25 - (M(:,1) - 5).^2 ) .* cos(2 .* (M(:,1) - 5))) + ((25 - (M(:,2) - 5).^2) .* cos(2 .* (M(:,2) - 5))) + 50;
fit_fun_2_mesh = @(x1,x2) ((25 - (x1 - 5).^2 ) .* cos(2 .* (x1 - 5))) + ((25 - (x2 - 5).^2) .* cos(2 .* (x2 - 5))) + 50;

% Początkowa macierz binarna
P0 = randi([0,1], m, l);

% Rysowaie przestrzeni rozwiązań
X1 = linspace(0,10,100);
X2 = linspace(0,10,100)';
Y = fit_fun_2_mesh(X1, X2);
figure;
surf(X1, X2, Y, EdgeColor="none", FaceAlpha=0.5);
hold on;
s3d = scatter3([], [], [], 75, 'filled', 'MarkerFaceColor', 'b', SizeData=200);

mean_fit_values = []
max_fit_values = []
Pi = P0;

for i = 0:lg

    % Dekodowanie populacji
    disp("Zdekodowana populacja");
    Pi_r = decode_n_dim_population(Pi, a, b, sub_genomes)

    % Obliczenie funckji celu
    disp("Wektor funkcji przystosowania");
    fitness = fit_fun_2_m(Pi_r)

    % Umieścić każdego osobnika, każdy punkt na scatterze,
    plot_3d_population(Pi_r, fitness, s3d);

    % Selekcja
    disp("Wybrane osobniki");
    Ps = spinning_wheel_selection(fitness, Pi)

    %Krzyżowanie
    disp("Osobniki po krzyżowaniu");
    Ps = uniform_crossover(Ps, pc)

    %Mutacja
    disp("Osobniki po mutacji");
    Ps = mutate(Ps, pm)

    max_fit_values = [max_fit_values ,max(fitness)];
    mean_fit_values = [mean_fit_values ,mean(fitness)];

    Pi = Ps;
end

x = 0:lg;
figure
plot(x, max_fit_values, x, mean_fit_values)
title("Max fitness values and mean fitness values over generations")
disp("Początkowa populacja")


% Dekodowanie populacji, konwersja wektorów binarnych do wektora liczb dziesiętnych, przeskalowanych do przedziału [a,b]
function xr_vector = decode_population(binary_population, a, b)
    L = size(binary_population, 2); 
    powers = (L-1):-1:0;
    weights = 2 .^ powers; 
    xd_vector = binary_population * weights'; 
    xr_vector = a + xd_vector .* (b - a) ./ (2^L - 1);
end

% Dekodowanie n wymiarowej populacji, podział łańcuchów na n genotypów i konersja każdego podłańcucha do przedziału [a,b]
% binary_population - genotyp
% a - dolna granica wartości na jaki ma być dekodowany genotyp
% b - górna granica wartości na jaki ma być dekodowany genotyp 
% sub_gens - dłiugości podciągów genotypu
function xr_matrix = decode_n_dim_population(binary_population, a, b, sub_gens)
    xr_matrix = [];    
    from = 0;
    to = 0;
    for i = 1:length(sub_gens)
        from = to + 1;
        to = to + sub_gens(i);
        xr_matrix = [xr_matrix, decode_population(binary_population(:, from:to), a, b)];
    end
    %Tutaj dekoduję każdą zmienną z postaci binarnej na zmienne x1, x2 ,x3
    %itd. Później zwracana jest cała zdekodowana populacja i liczone są
    %funckje celu. 
end

% Selekcję proporcjonalna / spinning wheel selection
% fitness - wektor wartości funkcji celu
% Pi - osobniki w postaci binarnej
function Ps = spinning_wheel_selection(fitness, Pi)
    Ps = [];
    fitness_sum = sum(fitness);
    spinning_wheel = cumsum(fitness ./ fitness_sum);
    m = size(Pi, 1);

    for j = 1:m
        r = rand();
        for k = 1:m
            if r < spinning_wheel(k)
                selected = k;
                break;
            end
        end
        Ps = [Ps; Pi(selected,:)];
    end
end

% Selekcja turniejowa / tournament selection
% fitness - wektor wartości funkcji celu
% Pi - osobniki w postaci binarnej
function Ps = tournament_selection(fitness, Pi)
    Ps = [];
    m = size(Pi, 1);

    for j = 1:m
        first_fighter = randi(m);
        second_fighter = randi(m);

        if(fitness(first_fighter) <= fitness(second_fighter))
            Ps = [Ps; Pi(second_fighter, :)];
        else
            Ps = [Ps; Pi(first_fighter, :)];
        end
    end
end

% Krzyżowanie jednopunktowe / One point crossover
% Ps - macierz selekcji
% pc - prawdopodobieństwo krzyżowania
function Ps = one_point_crossover(Ps, pc)
    m = size(Ps, 1);
    l = size(Ps, 2);

    for i = 1:m 
        if rand() < pc
            first = randi(m);
            second = randi(m);

            k = randi(l);
            Ps([first, second], k:end) = Ps([second, first], k:end);
        end
    end
end

% Krzyżowanie równomierne / Uniform crossover
% Ps - Macierz selekcji
% pc - prawdopodobieństwo krzyżowania
function Ps = uniform_crossover(Ps, pc)
    m = size(Ps, 1);
    l = size(Ps, 2);

    for i = 1:m
        if rand() < pc
            mask = randi([0, 1], 1, l)
            % Negacja maski pozwala na łatwiejsze przemnożenie przez indexy
            % które mają zostać zamieniane.
            mask = ~mask
            mask_indexes = 1:l
            mask_indexes = mask .* mask_indexes
            mask_indexes = nonzeros(mask_indexes)
            
            first = randi(m)
            second = randi(m)

            disp(Ps)
   
            Ps([first, second], mask_indexes) = Ps([second, first], mask_indexes)
        end
    end
end

% Mutacja
% Ps - macierz selekcji
% pm - prawdopodobieństwo mutacji
function Ps = mutate(Ps, pm)
    m = size(Ps, 1);
    l = size(Ps, 2);
    lm = floor(pm * l * m);

    for i = 1:lm
        row = randi(m);
        column = randi(l);

        if Ps(row, column) == 0
            Ps(row, column) = 1;
        else
            Ps(row, column) = 0;
        end
    end
end

% Funkcja rysująca populacje w przestrzeni 3D
% decoded population - zdekodowana populacja, gdzie każdy osobnik składa
% się z dwóch zmiennych x1, x2.
% fitness - wektor wartości funkcji celu populacji
% scatter - uchwyt do scatter3
function plot_3d_population(decoded_population, fitness, scatter)
    scatter.XData = decoded_population(:,1);
    scatter.YData = decoded_population(:,2);
    scatter.ZData = fitness;

    pause(0.1);
    
    drawnow limitrate;
end
