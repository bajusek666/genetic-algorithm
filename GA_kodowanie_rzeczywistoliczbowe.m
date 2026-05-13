
% Algortym genetyczny

% Inicjaliacja parametrów 

m = 16; % Liczba osobników
n = 2; % Wymiarowość przestrzeni poszukiwań
pc = 0.7; % prawdopodobieństwo krzyżowania
pm = 1; % Prawdopodobieństwo mutacji bitu
lg = 100; % Liczba generacji
low = 0; % Dolna granica zbioru wartości funkcji celu
high = 10; % Górna granica zbioru wartości funkcji celu
sigma = 0.1 % Odchylnie standardowe rozdkłądu Normalnego

% Funckje przystosowania
fit_fun = @(x) x + sin(3 + cos(5 * x)) + 0.8;
fit_fun_2 = @(x1,x2) ((25 - (x1 - 5)^2 ) * cos(2 * (x1 - 5))) + ((25 - (x2 - 5)^2) * cos(2 * (x2 - 5))) + 50;
fit_fun_2_m = @(M) ((25 - (M(:,1) - 5).^2 ) .* cos(2 .* (M(:,1) - 5))) + ((25 - (M(:,2) - 5).^2) .* cos(2 .* (M(:,2) - 5))) + 50;
fit_fun_2_mesh = @(x1,x2) ((25 - (x1 - 5).^2 ) .* cos(2 .* (x1 - 5))) + ((25 - (x2 - 5).^2) .* cos(2 .* (x2 - 5))) + 50;

% Początkowa populacja
P0 = low + (high - low) * rand(m, n);

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
Pi_r = P0;

for i = 0:lg

    % Obliczenie funckji celu
    disp("Wektor funkcji przystosowania");
    fitness = fit_fun_2_m(Pi_r);

    % Umieścić każdego osobnika, każdy punkt na scatterze,
    plot_3d_population(Pi_r, fitness, s3d);

    % Selekcja
    disp("Wybrane osobniki");
    Ps = spinning_wheel_selection(fitness, Pi_r)
     
    % %Krzyżowanie
    disp("Osobniki po krzyżowaniu");
    Ps = crossover(Ps, pc)
     
    % %Mutacja
    disp("Osobniki po mutacji");
    Ps = mutate(Ps, sigma, low, high)

    max_fit_values = [max_fit_values ,max(fitness)];
    mean_fit_values = [mean_fit_values ,mean(fitness)];

    Pi_r = Ps;
end

x = 0:lg;
figure
plot(x, max_fit_values, x, mean_fit_values)
title("Max fitness values and mean fitness values over generations")
disp("Początkowa populacja")


% Selekcję proporcjonalna / spinning wheel selection
% fitness - wektor wartości funkcji celu
% Pi_r - osobniki zakodowany rzeczywistoliczbowo
function Ps = spinning_wheel_selection(fitness, Pi_r)
    Ps = [];
    fitness_sum = sum(fitness);
    spinning_wheel = cumsum(fitness ./ fitness_sum);
    m = size(Pi_r, 1);

    for j = 1:m
        r = rand();
        for k = 1:m
            if r < spinning_wheel(k)
                selected = k;
                break;
            end
        end
        Ps = [Ps; Pi_r(selected,:)];
    end
end

% Selekcja turniejowa / tournament selection
% fitness - wektor wartości funkcji celu
% Pi_r - osobniki zakodowane rzeczywistoliczbowo
function Ps = tournament_selection(fitness, Pi_r)
    Ps = [];
    m = size(Pi_r, 1);

    for j = 1:m
        first_fighter = randi(m);
        second_fighter = randi(m);

        if(fitness(first_fighter) <= fitness(second_fighter))
            Ps = [Ps; Pi_r(second_fighter, :)];
        else
            Ps = [Ps; Pi_r(first_fighter, :)];
        end
    end
end

% Krzyżowanie arytmetyczne / Arithmetic crossover
% Ps - osobniki, kodowanie rzeczywistoliczbowe
% pc - prawdopodobieństwo krzyżowania
function Ps = crossover(Ps, pc)
    m = size(Ps, 1);

    for i = 1:m
        if rand() < pc
            first = randi(m);
            second = randi(m);
            alfa = rand();

            O1 = alfa * Ps(first,:) + (1-alfa) * Ps(second,:);
            O2 = (1 - alfa) * Ps(first,:) + alfa * Ps(second,:);

            Ps(first, :) = O1;
            Ps(second, :) = O2;
        end
    end
end

% Mutacja
% Ps - macierz selekcji
% sigma - odchylenie standardowe rozkładu normalnego
% low - dolna granica zbioru wartości funkcji celu
% high - górna granica zbioru wartości funkcji celu
function Ps = mutate(Ps, sigma, low, high)
    m = size(Ps, 1);
    
    for i = 1:m
        mutated = [Ps(i, 1) + sigma * randn(), Ps(i, 2) + sigma * randn()];
        if (any(mutated(:) < low) || any(mutated(:) > high))
            O1 = low + (high - low) * rand();
            O2 = low + (high - low) * rand();
            Ps(i,:) = [O1, O2];
        else
            Ps(i,:) = mutated;
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
