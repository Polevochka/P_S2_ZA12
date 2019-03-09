unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

const
  // Максималтная размер таблицы (в пикселях)
  MAX_TAB_SIZE = 350;

var
  Form1: TForm1;

  // Делаем матрицу и её размерность глобальными переменными
  // чтобы они были видны во всех функциях -
  // обработчиков нажатия кнопок
  M: Matr;
  n: integer;

implementation

{$R *.lfm}

{ TForm1 }

// удобно будет создать процедуру вывода матрицы в объект типа TStringGrid
// 'var tab :TStringGrid' т.к. мы будем изменять объект tab - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure DisplayMatrix(M: Matr; n: integer; var tab: TStringGrid);
var
  i,j: integer;
  size_one: integer; // ширина и высота одной ячейки таблицы
  s_x: string; // строковое представление элемента матрицы
begin
  // перед записью чего-то в таблицу tab очищаем её
  tab.Clean;

  tab.RowCount := n;  // Число столбцов
  tab.ColCount := n;  // Количестов строк   ТАБЛИЦЫ

  // Чтобы обращаться к атрибутам tab без точки
  // Например раньше надо было писать
  // 'tab.ColCount' , теперь же достаточно просто 'RowCount'
  with tab do
  begin

    {Устанавливаем одинаковую размер для всех ячеек, ячейки - КВАДРАТНЫЕ}
    // Сначала находим сколько пикселей на одну ячейчку
    size_one:= MAX_TAB_SIZE div n;

    // Нам нужно задать размер каждого столбца и каждой строки
    // так как таблица и матрица КВАДРАТНЫЕ и известна
    // ширина - размер столбца
    // высота - размер строки
    // причом это одно число size_one
    // то это можно сделать в одном цикле
    for i:= 0 to n -1 do
    begin
      RowHeights[i] := size_one; // для каждой строки одна и та же высота
      ColWidths[i] := size_one;   // для каждого столбца одна и та же ширина
    end;

    // устанавливаем общие размеры таблицы
    // То что мы делали выше - это только для ячеек
    // Таблица не будет увеличиваться если увеличить только размер ячейки
    // Если ячейка не влезает в видимую область таблицы,
    // то есть в  размер, что стоит по умолчанию
    // Тогда будут появляться ПОЛОСЫ ПРОКРУТКИ - СКРОЛБАР
    // + 10 - чтобы не добавлялся скролбар
    // будет пустое место - но это не критично
    height := MAX_TAB_SIZE+10;
    width := MAX_TAB_SIZE+10;

    // Теперь заполняем таблицу, элементами из матрицы
    for i:=0 to n-1 do
      for j:=0 to n-1 do
      begin
        // Столбцы и строки у ТАБЛИЦЫ нумеруются с нуля,
        // а в матрице с еденицы
        // поэтому обходим с 0 в циклах
        // и обращаемся к элементам МАТРИЦЫ так M[i+1, j+1]
        // Преобразуем число - елемент матрицы в СТРОКУ
        // Ячейки ТАБЛИЦЫ - это строки
        str(M[i+1, j+1], s_x);
        // Еслибы не with приходилось бы обращаться tab.Cells
        // Cells - по сути та же матрица - только нашей таблицы tab
        // И строки и столбцы у неё нумеруются с 0 - ЗАПОМНИТЕ
        // Также ВАЖНО помнить, что если обращаться к элементу МАТРИЦЫ
        // То мы пишем сначала номер строки потом столбца : M[i,j](если i,j > 1 конешн)
        // Но в Cells нужно СНАЧАЛА передавать номер СТОЛБЦА, и уже ПОТОМ номер СТРОКИ
        // То есть Cells[j,i] - НЕ опечатка
        Cells[j,i] := s_x;
      end;
  end;
end;


{Считываем матрицу из StringGrid}
// 'var' чтобы изменить переменные передавааемые в функцию
// table: TStringGrid без var т.к. мы только считываем оттуда
procedure ReadMatrix(var M: Matr; var n: integer; tab:TStringGrid);
var i, j: integer;

begin
  // Задаём размерность Матрицы
  // Т.к. матрица квадратная, то её размерность можн задать
  // числом столбцов ТАБЛИЦЫ
  n := tab.RowCount;
  // или числом строк ТАБЛИЦЫ
  // n:= tab.ColCount;

  // Теперь просто обходя все ячейки ТАБЛИЦЫ
  // Заполняем матрицу
  // здесь для примера мы НЕ ИСПОЛЬЗУЕМ with
  // чтобы показать как ещё можно обращаться к атрибутам tab
  for i:=0 to tab.RowCount-1 do
      for j:=0 to tab.ColCount-1 do
          // Помните в Celss СНАЧАЛА СТОЛБЕЦ, ПОТОМ СТРОКУ
          // Так как ячейка таблицы - ЭТО СТРОКА, а элемент матрицы - ЧИСЛО
          // то строку нужно привести к целому числу
          M[i+1, j+1] := StrToInt(tab.Cells[j,i]);

end;

{Нажали 'Ввести матрицу'}
procedure TForm1.Button1Click(Sender: TObject);
begin

  // Получаем размерность матрицы от пользователя
  // InputBox возвращает строку, но ГЛОБАЛЬНАЯ переменная 'n' типа integer
  // поэтому преобразуем возвращаем значение в целое число при помощи StrToInt
  n := StrToInt(InputBox('Размерность матрицы', 'Введите целое число', '5'));

  // Теперь так как УЖЕ ЕСТЬ число строк и столбцов
  // Заполняем матрицу
  randomize; // для генератора случайных чисел
  RandomMatrix(M, n);

  // выводим матрицу в StringGrid1 - исходная матрица
  DisplayMatrix(M, n, StringGrid1);

end;

{Нажали кнопку 'Влево'}
procedure TForm1.Button2Click(Sender: TObject);
begin
  // Считывам матрицу из StringGrid1 и узнаём число строк и столбцов
   ReadMatrix(M, n, StringGrid1);

  // Передвигаем диагональные элементы в строках ВЛЕВО
  MoveLeft(M, n);

  // и выводим полученную матрицу в StringGrid2
  DisplayMatrix(M, n, StringGrid2);
end;

{Нажали кнопку 'Вправо'}
procedure TForm1.Button3Click(Sender: TObject);
begin
  // Считывам матрицу из StringGrid1 и узнаём число строк и столбцов
   ReadMatrix(M, n, StringGrid1);

  // Передвигаем диагональные элементы в строках ВПРАВО
  MoveRight(M, n);

  // и выводим полученную матрицу в StringGrid2
  DisplayMatrix(M, n, StringGrid2);
end;

{Нажали 'Закрыть' - выход из программы}
procedure TForm1.Button4Click(Sender: TObject);
begin
  close;
end;

end.

