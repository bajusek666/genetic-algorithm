
% Algortym genetyczny

% Inicjaliacja parametrów 

m = 16; % Liczba osobników
sub_genomes = [10,10]; % Długość poszczególnych podciągów (kolejnych zmiennych reprezentowanych przez genom)
l = sum(sub_genomes);
pc = 0.7; % prawdopodobieństwo krzyżowania
pm = 0.01; % Prawdopodobieństwo mutacji bitu
lg = 100; % Liczba generacji
low = 0;
high = 10;

ga_params.pc = pc;
ga_params.pm = pm;
ga_params.lg = lg;
ga_params.low = low;
ga_params.high = high;
ga_params.sub_genomes = sub_genomes;
ga_params.l = l;
ga_params.m = m;
ga_params.mutate = true; 
ga_params.crossover = true;
ga_params.population_zeros = false;

% Funckje przystosowania
fit_fun = @(x) x + sin(3 + cos(5 * x)) + 0.8;
fit_fun_2 = @(x1,x2) ((25 - (x1 - 5)^2 ) * cos(2 * (x1 - 5))) + ((25 - (x2 - 5)^2) * cos(2 * (x2 - 5))) + 50;
fit_fun_2_m = @(M) ((25 - (M(:,1) - 5).^2 ) .* cos(2 .* (M(:,1) - 5))) + ((25 - (M(:,2) - 5).^2) .* cos(2 .* (M(:,2) - 5))) + 50;
ga_params.fit_fun_2_m = fit_fun_2_m;
fit_fun_2_mesh = @(x1,x2) ((25 - (x1 - 5).^2 ) .* cos(2 .* (x1 - 5))) + ((25 - (x2 - 5).^2) .* cos(2 .* (x2 - 5))) + 50;

% Rysowaie przestrzeni rozwiązań
% X1 = linspace(0,10,100);
% X2 = linspace(0,10,100)';
% Y = fit_fun_2_mesh(X1, X2);
% figure;
% surf(X1, X2, Y, EdgeColor="none", FaceAlpha=0.5);
% hold on;
% s3d = scatter3([], [], [], 75, 'filled', 'MarkerFaceColor', 'high', SizeData=200);

% Parametry eksperymentu
m_values = [10, 20, 40];
pc_values = [0.25, 0.5, 0.75, 1];
pm_values = [0.01, 0.05, 0.001];

num_runs = 15;
colors = ["r", "g", "b", "m"];

% Zmienna ilość osobników
figure;
hold on;

for idx = 1:length(m_values)
    ga_params.m = m_values(idx);

    for run = 1:num_runs
        [current_max, current_mean] = ga_main_loop(ga_params); % Uruchomienie głównej pętli algoytmu GA
        all_max_runs(run, :) = current_max;
        all_mean_runs(run, :) = current_mean;
    end

    avg_max_fit = mean(all_max_runs, 1);
    avg_mean_fit = mean(all_mean_runs, 1);

    x = 0:ga_params.lg;
    plot(x, avg_max_fit, Color=colors(idx), LineWidth=2, DisplayName=sprintf("Max (m = %d)", m_values(idx)));
    plot(x, avg_mean_fit, ':', Color=colors(idx), LineWidth=2, DisplayName=sprintf("Mean (m = %d)", m_values(idx)));
end

title("Max i Mean fitness, zmienna ilość osobników.");
xlabel("Generacja");
ylabel("Fitness");
legend('show', 'Location', 'best', 'FontSize', 14);
grid on;
hold off;

% Zmienne prawdopodobieństwo krzyżowania
figure;
hold on;

for idx = 1:length(pc_values)
    ga_params.m = 40;
    ga_params.pc = pc_values(idx);

    for run = 1:num_runs
        [current_max, current_mean] = ga_main_loop(ga_params);
        all_max_runs(run, :) = current_max;
        all_mean_runs(run, :) = current_mean;
    end

    avg_max_fit = mean(all_max_runs, 1);
    avg_mean_fit = mean(all_mean_runs, 1);

    x = 0:ga_params.lg;
    plot(x, avg_max_fit, Color=colors(idx), LineWidth=2, DisplayName=sprintf("Max (pc = %f)", pc_values(idx)));
    plot(x, avg_mean_fit, ':', Color=colors(idx), LineWidth=2, DisplayName=sprintf("Mean (pc = %f)", pc_values(idx)));
end

title("Max i Mean fitness, zmienne pc, m = 40, pm = 0.01");
xlabel("Generacja");
ylabel("Fitness");
legend('show', 'Location', 'best', 'FontSize', 14);
grid on;
hold off;

% Zmienne prawdopodobieństwo mutacji

figure;
hold on;

for idx = 1:length(pm_values)
    ga_params.pc = 0.5;
    ga_params.m = 40;

    for run = 1:num_runs
        [current_max, current_mean] = ga_main_loop(ga_params);
        all_max_runs(run, :) = current_max;
        all_mean_runs(run, :) = current_mean;
    end

    avg_max_fit = mean(all_max_runs, 1);
    avg_mean_fit = mean(all_mean_runs, 1);

    x = 0:ga_params.lg;
    plot(x, avg_max_fit, Color=colors(idx), LineWidth=2, DisplayName=sprintf("Max (pm = %f)", pm_values(idx)));
    plot(x, avg_mean_fit, ':', Color=colors(idx), LineWidth=2, DisplayName=sprintf("Mean (pm = %f)", pm_values(idx)));
end

title("Max i Mean fitness, zmienne prawdopodobieństwo mutacji.");
xlabel("Generacja");
ylabel("Fitness");
legend('show', 'Location', 'best', 'FontSize', 14);
grid on;
hold off;

% Wybrane parametry
ga_params.m = 40;
ga_params.pc = 0.5;
ga_params.pm = 0.01;

% Wpływ obecności operatorów na algorytm, losowa populacja początkowa

%Pierwsza kolumna: Krzyżowanie
%Druga kolumna: Mutacja
combinations = [true, true; false, true; true, false; false, false];

figure;
hold on;

for idx = 1:length(combinations)

    ga_params.crossover = combinations(idx, 1);
    ga_params.mutate = combinations(idx, 2);

    for run = 1:num_runs
        [current_max, current_mean] = ga_main_loop(ga_params);
        all_max_runs(run, :) = current_max;
        all_mean_runs(run, :) = current_mean;
    end

    avg_max_fit = mean(all_max_runs, 1);
    avg_mean_fit = mean(all_mean_runs, 1);

    x = 0:ga_params.lg;
    plot(x, avg_max_fit, Color=colors(idx), LineWidth=2, DisplayName=sprintf("Max (Krzyżowanie: %d, Mutacja: %d)", combinations(idx, 1), combinations(idx,2)));
    plot(x, avg_mean_fit, ':', Color=colors(idx), LineWidth=2, DisplayName=sprintf("Mean (Krzyżowanie: %d, Mutacja: %d)", combinations(idx, 1), combinations(idx,2)));
end

title("Max i Mean fitness, zmienna obecność operatorów");
xlabel("Generacja");
ylabel("Fitness");
legend('show', 'Location', 'best', 'FontSize', 14);
grid on;
hold off;

% Wpływ obecności operatorów na algorytm, zerowa populacja początkowa
ga_params.population_zeros = true;

figure;
hold on;

for idx = 1:length(combinations)

    ga_params.crossover = combinations(idx, 1);
    ga_params.mutate = combinations(idx, 2);

    for run = 1:num_runs
        [current_max, current_mean] = ga_main_loop(ga_params);
        all_max_runs(run, :) = current_max;
        all_mean_runs(run, :) = current_mean;
    end

    avg_max_fit = mean(all_max_runs, 1);
    avg_mean_fit = mean(all_mean_runs, 1);

    x = 0:ga_params.lg;
    plot(x, avg_max_fit, Color=colors(idx), LineWidth=2, DisplayName=sprintf("Max (Krzyżowanie: %d, Mutacja: %d)", combinations(idx, 1), combinations(idx,2)));
    plot(x, avg_mean_fit, ':', Color=colors(idx), LineWidth=2, DisplayName=sprintf("Mean (Krzyżowanie: %d, Mutacja: %d)", combinations(idx, 1), combinations(idx,2)));
end

title("Max i Mean fitness, zmienna obecność operatorów, zerowa populacja początkowa");
xlabel("Generacja");
ylabel("Fitness");
legend('show', 'Location', 'best', 'FontSize', 14);
grid on;
hold off;

% Dekodowanie populacji, konwersja wektorów binarnych do wektora liczb dziesiętnych, przeskalowanych do przedziału [low,high]
function xr_vector = decode_population(binary_population, low, high)
    L = size(binary_population, 2); 
    powers = (L-1):-1:0;
    weights = 2 .^ powers; 
    xd_vector = binary_population * weights'; 
    xr_vector = low + xd_vector .* (high - low) ./ (2^L - 1);
end

% Dekodowanie n wymiarowej populacji, podział łańcuchów na n genotypów i konersja każdego podłańcucha do przedziału [low,high]
% binary_population - genotyp
% low - dolna granica wartości na jaki ma być dekodowany genotyp
% high - górna granica wartości na jaki ma być dekodowany genotyp 
% sub_gens - dłiugości podciągów genotypu
function xr_matrix = decode_n_dim_population(binary_population, low, high, sub_gens)
    xr_matrix = [];    
    from = 0;
    to = 0;
    for i = 1:length(sub_gens)
        from = to + 1;
        to = to + sub_gens(i);
        xr_matrix = [xr_matrix, decode_population(binary_population(:, from:to), low, high)];
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
            mask = randi([0, 1], 1, l);
            % Negacja maski pozwala na łatwiejsze przemnożenie przez indexy
            % które mają zostać zamieniane.
            mask = ~mask;
            mask_indexes = 1:l;
            mask_indexes = mask .* mask_indexes;
            mask_indexes = nonzeros(mask_indexes);
            
            first = randi(m);
            second = randi(m);
   
            Ps([first, second], mask_indexes) = Ps([second, first], mask_indexes);
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

% Głowna pętla algorytmu genetycznego
% Przyjmuje strukturę z parametrami aglorytmu GA
function [max_fit_values, mean_fit_values] = ga_main_loop(ga_params)

    if(ga_params.population_zeros)
        Pi = zeros(ga_params.m, ga_params.l);
    else
        Pi = create_initial_population(ga_params.m, ga_params.l);
    end
    low = ga_params.low;
    high = ga_params.high;
    sub_genomes = ga_params.sub_genomes;
    pc = ga_params.pc;
    pm = ga_params.pm;
    lg = ga_params.lg;
    fit_fun_2_m = ga_params.fit_fun_2_m;
    mean_fit_values = [];
    max_fit_values = [];

    for i = 0:lg
        Pi_r = decode_n_dim_population(Pi, low, high, sub_genomes);
        fitness = fit_fun_2_m(Pi_r);
        % plot_3d_population(Pi_r, fitness, s3d);
        Ps = spinning_wheel_selection(fitness, Pi);

        if(ga_params.mutate)
            Ps = uniform_crossover(Ps, pc);
        end
        if(ga_params.crossover)
            Ps = mutate(Ps, pm);
        end

        max_fit_values = [max_fit_values ,max(fitness)];
        mean_fit_values = [mean_fit_values ,mean(fitness)];
    
        Pi = Ps;
    end
end 

% Utworzenie jednakowej początkowej populacji
% m - liczba osobników
% l - długość genotypu
function P0 = create_initial_population(m, l)
    rng_seed = rng;
    rng(100);
    P0 = randi([0,1], m, l);
    rng(rng_seed);
end
