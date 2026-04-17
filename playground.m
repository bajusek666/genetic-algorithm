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

%
disp(size(xd_matrix));
matrix = [1,2,3;4,5,6];
disp(matrix)
matrix = matrix'
matrix = matrix'



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

%Selekcja rzędów i kolumn z macierzy;

random_matrix = randi([0,10], 5, 5);
disp(random_matrix)

disp(random_matrix(5, :));

%Swap wierszy, zamiana wierszy
% PS = [1,2,3,4; 5,6,7,8; 0,0,0,0];

k = 2;
first = 1;
second = 3;

%Maskowanie 
% PS = [1,1,1,1; 2,2,2,2; 3,3,3,3];
% mask = randi([0, 1], 1, l)
% mask = ~mask
% mask_indexes = 1:l
% mask_indexes = mask .* mask_indexes
% mask_indexes = nonzeros(mask_indexes)

arr = [1,2,3,4,5];
disp(length(arr));

z = peaks(25);
surf(z);

[X,Y] = meshgrid(1:0.5:10, 1:20);
disp(X)
Z = sin(X) + cos(X)

fit_fun_2 = @(x1,x2) ((25 - (x1 - 5).^2 ) .* cos(2 .* (x1 - 5))) + ((25 - (x2 - 5).^2) .* cos(2 .* (x2 - 5))) + 50;
X1 = linspace(0,10,100)
X2 = linspace(0,10,100)'
Y = fit_fun_2(X1, X2)
figure;
surf(X1, X2, Y)
hold on;

x = [1,2,3]
y = [2,3,4]
z = [5,5,5]
scatter3(x,y,z)