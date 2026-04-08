% X = [1, 2, 3, 4; 1, 2, 3, 4; 1, 2, 3, 4];
% disp(size(X, 2));

%size(A) - zwraca wektor z rozmiarem kolejnych wymiarów macierzy A.
%size(A, dim) - zwraca rozmiar wymiaru dim, macierzy A. size(A, 2) zwróci ilość kolumn macierzy A.

%generowanie ciągów liczbowych
% początek:krok:koniec

% .^ potęgowanie 

%Iloczyn Hadamarda, mnożenie element-wise. kropka przed operatorem .^ , .*

%Iloczyn skalarny, mnożenie macierzowe bez kropki ^, *, 

binary_population = [1,0,1;1,1,1;0,0,1];
disp(binary_population);

powers = 2:-1:0;
disp(powers);
weights = 2 .^ powers;
disp(weights');

%mnoże macierzowo macierz binary_population 3x3 przez transponowany wektor
%z wagami 3x1

xd_matrix = binary_population * weights';
disp(xd_matrix);

suma_jakosci = sum(xd_matrix);
Pi = xd_matrix ./ suma_jakosci;
disp(Pi)
%losowanie osobnika, suma skumulowana, cumulative sum

Pi_cumsum = cumsum(Pi)

%losuję liczbę rzeczywistą z rozkładu jednostajnego 

r = rand();
disp(r)
n = length(Pi);

for i = 1:n
    if r < Pi_cumsum(i)
        selectedIndividual = i;
        break;
    end
end

disp(selectedIndividual)