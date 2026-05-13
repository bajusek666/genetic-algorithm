%Algortym genetyczny

%Inicjaliacja parametrów
m = 16; %Liczba osobników
l = 20; %Długość genomu
pc = 0.7; % prawdopodobieństwo krzyżowania
pm = 0.01; %Prawdopodobieństwo mutacji bitu
lg = 100; %Liczba generacji

%początkowa macierz binarna
P0 = randi([0,1], m, l)

meanFitnessValues = []
maxFitnessValues = []

for i = 0:lg
    %policzyć funkcję celu dla każdego osobnika
    fitness = sum(P0,2)

    %Macierz selekcji
    PS = []

    for j = 1:m
        %losuje parę, 2 liczby z przedziału od 1 do m 
        firstFighter = randi(m)
        secondFighter = randi(m)
    
        %walka
        if(fitness(firstFighter) <= fitness(secondFighter))
            winner = P0(secondFighter, :)
        else
            winner = P0(firstFighter, :)
        end

        PS = [PS; winner]
    end

    %Losuję dwa dowolne osobniki
    %Losuję k od którego zamieniam genotyp osobnika
    %Zamieniam genotypy osobników

    for j = 1:m
        first = randi(m)
        second = randi(m)
        
        if rand() < pc
           k = randi(l)
           firstTail = PS(first, k:end)
           secondTail = PS(second, k:end)
           PS(first, k:end) = secondTail
           PS(second, k:end) = firstTail
        end
    end

    %Mutacja
    %Liczymy ile mutacji w macierzy
    %Losujemy punkty do mutacji
    
    lm = floor(pm * l * m)

    for j = 1:lm
        row = randi(m)
        column = randi(l)
        %mutacja wylosowanego punktu
        if PS(row, column) == 0
            PS(row, column) = 1
        else
            PS(row, column) = 0
        end
    end

    maxFitnessValues = [maxFitnessValues ,max(fitness)]
    meanFitnessValues = [meanFitnessValues ,mean(fitness)]

    P0 = PS
end

x = 0:lg
figure
plot(x, maxFitnessValues, x, meanFitnessValues)
title("Max fitness values and mean fitness values over generations")
