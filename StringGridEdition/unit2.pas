unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  // создадим тип для матрицы
  // нужен для передачи матрицы в функции обработки
  // кстати т.к. он в области interface и этот модуль мы подключаем в unit1
  // то этот тип можо будет использовать в unit1
  Matr = array[1..15, 1..15] of integer;

// прототипы функций которые ДОЛЖНЫ быть ВЫДНЫ в ДРУГИХ модулях(unit1)
procedure RandomMatrix(var M: Matr; n: integer);
procedure MoveRight(var M: Matr; n: integer);
procedure MoveLeft(var M: Matr; n: integer);

implementation

{Процедура заполнения матрицы рандомными числами}
// здесь ВАЖНАЯ ПОПРАВОЧКА
//т.к. этот модуль компилируется отдельно от основной программы
// то randomize в нём работать не будет
// randomize надо вызывать в основной программе
//'var M' - т.к. меняем элементы матрицы
//  'n' - разменрность матрицы - число строк и столбцов
procedure RandomMatrix(var M: Matr; n : integer);
var i, j: integer;
begin
   for i:=1 to n do
       for j:=1 to n do
           M[i,j] := 1 + random(100); // рандомное число на отрезке [1;100]
end;


{Процедура перемещает элементы с главной диагонали ВПАРАВО}
procedure MoveRight(var M:Matr; n: integer);
var
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим все сстроки
  for i:=1 to n do
  begin

    // Для начала стоит вспомнить как задаются элементы,
    // лежашщие на главной диагнали
    // Главная диагональ - это когда номер СТРОКИ = номеру СТОЛБЦА
    // то есть элемент с индексом M[i,i];

    // Переместим этот элемент в ВПРАВО,
    // то есть в КОНЕЦ i-ой строки матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[i, i];

    // Потом смещаем все элементы ПРАВЕЕ его ВЛЕВО на одну позицию(затирая его)
    //   -От j=i, не забываем , что для элемента, лежащего на главной диагонали,
    //    номер строки = номеру столбца
    //   -До cols-1, т.к. если j=cols то получится M[i, j] = M[i, cols+1]
    //    НЕТ такого элемента
    for j := i to n-1 do
        M[i, j]:= M[i, j+1];

    {
        То есть
        было :   1 2 3 diag_el 4 5
        стало:   1 2 3 4 5 5
    }

    // нетрудно заметить, что теперь два последних элемента строки дублируются
    // теперь мы как раз можем записать на ПОСЛЕДНЕЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[i,n] := temp;
    // стало :  1 2 3 4 5 diag_el

    // задача для одной строки выполнена, переходим к другой строке
  end;
end;


{Процедура перемещает элементы с главной диагонали ВЛЕВО}
procedure MoveLeft(var M:Matr; n: integer);
var
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим все сстроки
  for i:=1 to n do
  begin

    // Для начала стоит вспомнить как задаются элементы,
    // лежашщие на главной диагнали
    // Главная диагональ - это когда номер СТРОКИ = номеру СТОЛБЦА
    // то есть элемент с индексом M[i,i];

    // Переместим этот элемент в ВЛЕВО,
    // то есть в НАЧАЛО i-ой строки матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[i, i];

    // Потом смещаем все элементы ЛЕВЕЕ его ВПРАВО на одну позицию(затирая его)
    //   -От j=i, не забываем , что для элемента, лежащего на главной диагонали,
    //    номер строки = номеру столбца
    //   -До 2, т.к. если j=1 то получится M[i, j] = M[i, 1-1] = M[i, 0]
    //    НЕТ такого элемента
    for j := i downto 2 do
        M[i, j]:= M[i, j-1];

    {
        То есть
        было :   1 2 3 diag_el 4 5
        стало:   1 1 2 3 4 5
    }

    // нетрудно заметить, что теперь два первых элемента строки дублируются
    // теперь мы как раз можем записать на ПЕРВОЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[i,1] := temp;
    // стало :  diag_el 1 2 3 4 5

    // задача для одной строки выполнена, переходим к другой строке
  end;
end;



end.

