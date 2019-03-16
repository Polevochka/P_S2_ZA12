unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

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

// удобно будет создать процедуру вывода матрицы в объект типа TMemo
// 'var AMemo:TMemo' так как мы будем изменять объект Memo - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure DisplayMatrix(M: Matr; n: integer; var AMemo: TMemo);
var
  // строковое представление одного числа
  s_x: string;
  // вспомогательная строка, чтобы добавить элементы матрицы
  // то есть это сумма строковых представлений каждого элемента(s_x) матрциы
  s: string;
  // переменные для циклов обхода матрицы
  i,j: integer;
begin
  // перед записью чего-то в Memo очищаем его
  // В Memo могла остаться старая матрица
  AMemo.Clear;

  // сначала мы будем собирать строку из элементов матрицы,
  // лежащих на i-ой строчке
  // Потом добавляем эту строку в Memo через Append
  for i:=1 to n do
  begin
    // присваиваем пустую строку про обработке каждой строки матрицы
    // То есть обработали одну строку, очистили переменную, обработать другую
    // иначе элементы с другой (предыдущей) строки будут выводиться и в новой строке
    s := '';
    for j:=1 to n do
    begin
      // преобразуем елемент матрицы в строку
      // число 5 - так же как и в writeln - ширина поля под число
      // чтобы не замарачиваться с пробелами при выводе
      str(M[i,j]:5, s_x);
      // по одному элементы i-ой строки собираем в одну строку
      s := s + s_x;
    end;
    // собрали одну строку, теперь добавляем её в Memo
    AMemo.Append(s);

  end;
end;


{Нажали 'Ввод матрицы'}
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

  // выводим матрицу в Memo1 - исходная матрица
  DisplayMatrix(M, n, Memo1);

end;

{Нажали кнопку 'Влево'}
procedure TForm1.Button2Click(Sender: TObject);
begin
  // Сама матрица 'M' и её размерность 'n' УЖЕ ЗАДАНЫ в {Ввод матрицы}
  // Эти переменные глобальные их можно использовать во всех процедурах
  // этого модуля, включая и эту

  // Передвигаем диагональные элементы в строках ВЛЕВО
  MoveLeft(M, n);
  // и выводим полученную матрицу в Memo2
  DisplayMatrix(M, n, Memo2);
end;

{Нажали кнопку 'Вправо'}
procedure TForm1.Button3Click(Sender: TObject);
begin
  // Сама матрица 'M' и её размерность 'n' УЖЕ ЗАДАНЫ в {Ввод матрицы}
  // Эти переменные глобальные их можно использовать во всех процедурах
  // этого модуля, включая и эту

  // Передвигаем диагональные элементы в строках ВПРАВО
  MoveRight(M, n);
  // и выводим полученную матрицу в Memo2
  DisplayMatrix(M, n, Memo2);
end;

{Нажали 'Закрыть' - выход из программы}
procedure TForm1.Button4Click(Sender: TObject);
begin
  close;
end;

end.

