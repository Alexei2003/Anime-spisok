Program Anime;

{$APPTYPE CONSOLE}

Uses
  SysUtils,
  Windows;

Const
  Str = '|------------------------------------------------------------------------------------------------------|';


Type
  //0 -	В планах
  //1 - Смотрю
  //2 - Просмотрено
  //3 - Брошено
  //4 - Отложено
  Ukazatel=^TAnime;

  TAnime=Record
    Name: String;
    Status: Byte;
    Next: Ukazatel;
  End;

Var
  Pred, Now, Head, Fin, Poftor: Ukazatel;
  Address, S, S2: String;
  WhDo: String;
  Finish, Flag, SortName: Boolean;
  F: TextFile;
  // количество аниме со статусом
  N1, N2, N3, N4, N5: Integer;


Function Standart(Const Numb: byte; Const Str: String): String;
Const
  NulStr = '                                                                                          ';
Begin
  Result:=NulStr;
  If Length(Str)<Numb Then
  Begin
    move(Str[1], Result[1], Length(Str));
  End;
End;

Procedure ShowSpisok(Const Name: String; Const Status: Byte);
Const
  Str = '|------------------------------------------------------------------------------------------------------|';
Var
  S: String;
Begin
  S:=Standart(90, Name);
  Write('|'+S);
  Case Status Of
    0:
      Writeln(' В планах   |');
    1:
      Writeln(' Смотрю     |');
    2:
      Writeln(' Просмотрено|');
    3:
      Writeln(' Брошено    |');
    4:
      Writeln(' Отложено   |');
  End;
  Writeln(Str);
End;

Procedure Search(Const S1: String; Var Now, Poftor: Ukazatel; Var Flag: Boolean);
Var
  S: String;
  L: Integer;
Begin
  Flag:=False;
  While Now<>nil Do
  Begin
    If Length(S1)<=Length(Now^.Name) Then
      L:=Length(S1)
    Else
      L:=Length(Now^.Name);
    S:=Copy(Now^.Name, 1, L);
    If S=S1 Then
    Begin
      Writeln;
      Poftor:=Now;
      ShowSpisok(Now^.Name, Now^.Status);
      Flag:=True;
    End;
    Now:=Now^.Next;
  End;
End;

Procedure Add(Var Pred, Start: Ukazatel);
Var
  Now, Start2, Poftor: Ukazatel;
  S: String;
  Flag: Boolean;
Begin
  New(Now);
  Now^.Next:=nil;
  Writeln('Название');
  Repeat
    Readln(Now^.Name);
  Until Length(Now^.Name)<>0;
  Flag:=False;
  Start2:=Start;
  Search(Now^.Name, Start2, Poftor, Flag);
  If Not Flag Then
  Begin
    Writeln('Статус');
    Writeln('1.В планах');
    Writeln('2.Смотрю');
    Writeln('3.Просмотрено');
    Writeln('4.Брошено');
    Writeln('5.Отложено');
    Repeat
      Readln(S);
    Until ((S='1') Or (S='В планах') Or
    			 (S='2') Or (S='Смотрю') Or
           (S='3') Or (S='Просмотрено') Or
           (S='4') Or (S='Брошено') Or
           (S='5') Or (S='Отложено'));
    If (S='1') Or (S='В планах') Then
      Now^.Status:=0
    Else
    Begin
      If (S='2') Or (S='Смотрю') Then
        Now^.Status:=1
      Else
      Begin
        If (S='3') Or (S='Просмотрено') Then
          Now^.Status:=2
        Else
        Begin
          If (S='4') Or (S='Брошено') Then
            Now^.Status:=3
          Else
          Begin
            If (S='5') Or (S='Отложено') Then
              Now^.Status:=4
          End;
        End;
      End;
    End;
    Pred.Next:=Now;
    Pred:=Now;
  End
  Else
  Begin
    Writeln('Уже добавлено');
  End;
End;

Procedure Sort(Var PredPred, Pred, Now: Ukazatel);
Var
  Buff: Ukazatel;
Begin
  PredPred^.Next:=Now;
  Pred^.Next:=Now^.Next;
  Now^.Next:=Pred;
  Buff:=Now;
  Now:=Pred;
  Pred:=Buff;
End;

Procedure Bubl(Const Head: Ukazatel; Const SortName: Boolean);
Var
  Flag, Finish: Boolean;
  PredPred, Pred, Now: Ukazatel;
  i: Byte;

Begin
  Flag:=True;
  While Flag Do
  Begin
    PredPred:=Head;
    Pred:=PredPred^.Next;
    Now:=Pred^.Next;
    Flag:=False;
    While Now<>nil Do
    Begin
      If SortName Then
      Begin
        i:=1;
        Finish:=False;
        While (i<90) And (Not Finish) Do
        Begin
          If Pred^.Name[i]>Now^.Name[i] Then
          Begin
            Sort(PredPred, Pred, Now);
            Flag:=True;
            Finish:=True;
          End
          Else
          Begin
            If Pred^.Name[i]<Now^.Name[i] Then
              Finish:=True;
          End;
          Inc(i);
        End;
      End
      Else
      Begin
        If Pred^.Status>Now^.Status Then
        Begin
          Sort(PredPred, Pred, Now);
          Flag:=True;
        End
      End;
      PredPred:=PredPred^.Next;
      Pred:=Pred^.Next;
      Now:=Now^.Next;
    End;
  End;
End;

Procedure Del(Var Start: Ukazatel);
Var
  S, S1: String;
  Pred, Now: Ukazatel;
  L: Integer;
Begin
  Writeln('Название');
  Repeat
    Readln(S1);
  Until Length(S1)<>0;
  Flag:=False;
  Pred:=Start;
  Now:=Pred.Next;
  While (Now<>nil) And (Not Flag) Do
  Begin
    If Length(S1)<=Length(Now^.Name) Then
      L:=Length(S1)
    Else
      L:=Length(Now^.Name);
    S:=Copy(Now^.Name, 1, L);
    If S=S1 Then
    Begin
      Flag:=True;
      Pred^.Next:=Now^.Next;
      Dispose(Now);
    End;
    Pred:=Pred^.Next;
    Now:=Now^.Next;
  End;
End;

Procedure Change(Var Start: Ukazatel);
Var
  S: String;
  Start2, Now: Ukazatel;
  Flag: Boolean;
Begin
  Writeln('Название');
  Repeat
    Readln(S);
  Until Length(S)<>0;
  Start2:=Start;
  Search(S, Start2, Now, Flag);
  Writeln('Что изменить?');
  Writeln('1.Название');
  Writeln('2.Статус');
  Repeat
    Readln(S);
  Until ((S='1') Or (S='Название') Or (S='2') Or (S='Статус'));
  If (S='1') Or (S='Название') Then
  Begin
    Writeln('Новое название');
    Repeat
      Readln(S);
    Until Length(S)<>0;
    Now^.Name:=S;
  End
  Else
  Begin
    Writeln('Новый статус');
    Writeln('1.В планах');
    Writeln('2.Смотрю');
    Writeln('3.Просмотрено');
    Writeln('4.Брошено');
    Writeln('5.Отложено');
    Repeat
      Readln(S);
    Until ((S='1') Or (S='В планах') Or
           (S='2') Or (S='Смотрю') Or
           (S='3') Or (S='Просмотрено') Or
           (S='4') Or (S='Брошено') Or
           (S='5') Or (S='Отложено'));
    If (S='1') Or (S='В планах') Then
      Now^.Status:=0
    Else
    Begin
      If (S='2') Or (S='Смотрю') Then
        Now^.Status:=1
      Else
      Begin
        If (S='3') Or (S='Просмотрено') Then
          Now^.Status:=2
        Else
        Begin
          If (S='4') Or (S='Брошено') Then
            Now^.Status:=3
          Else
          Begin
            If (S='5') Or (S='Отложено') Then
              Now^.Status:=4
          End;
        End;
      End;
    End;
  End;
End;

Begin
  SetConsoleCp(1251);
  SetConsoleOutputCP(1251);
  Address:='data.anim';
  AssignFile(F, Address);
  Reset(F);
  New(Head);
  Pred:=Head;
  Now:=Head;
  While Not Eof(F) Do
  Begin
    New(Now);
    Readln(F, Now^.Name);
    Readln(F, Now^.Status);
    Pred^.Next:=Now;
    Pred:=Now;
  End;
  Now.Next:=nil;
  Fin:=Now;

  Repeat
    Finish:=False;
    writeln('Выберите действие');
    Writeln('1.Просмотреть список');
    Writeln('2.Изменить');
    Writeln('3.Найти');
    Writeln('4.Отсортировать');
    Writeln('5.Сохранение');
    Writeln('6.Выход');
    Repeat
      Readln(WhDo);
    Until ((WhDo='1') Or (WhDo='Просмотреть список') Or
           (WhDo='2') Or (WhDo='Добавить') Or
           (WhDo='3') Or (WhDo='Найти') Or
           (WhDo='4') Or (WhDo='Отсортировать') Or
           (WhDo='5') Or (WhDo='Сохранение') Or
           (WhDo='6') Or (WhDo='Выход'));
    Writeln;

    If (WhDo='1') Or (WhDo='Просмотреть список') Then
    Begin
      N1:=0;
      N2:=0;
      N3:=0;
      N4:=0;
      N5:=0;
      Reset(F);
      Now:=Head^.Next;
      Writeln(Str);
      While Now<>nil Do
      Begin
        Case Now.Status Of
          0:
            Inc(N1);
          1:
            Inc(N2);
          2:
            Inc(N3);
          3:
            Inc(N4);
          4:
            Inc(N5);
        End;
        ShowSpisok(Now.Name, Now.Status);
        Now:=Now^.Next;
      End;
      Writeln('Количество в планах = ', N1);
      Writeln('Количество смотрю = ', N2);
      Writeln('Количество просмотрено = ', N3);
      Writeln('Количество брошено = ', N4);
      Writeln('Количество отложено = ', N5);
    End
    Else
    Begin
      If (WhDo='2') Or (WhDo='Изменить') Then
      Begin
        Writeln('1.Добавить');
        Writeln('2.Удалить');
        Writeln('3.Изменить');
        Repeat
          Readln(s2);
        Until ((s2='1') Or (s2='Добавить') Or (S2='2') Or (S2='Удалить') Or (S2='3') Or (s2='Изменить'));
        Writeln;
        Repeat
          If (s2='1') Or (s2='Добавить') Then
            Add(Fin, Head^.Next)
          Else
          Begin
            If (S2='2') Or (S2='Удалить') Then
              Del(Head)
            Else
              Change(Head^.Next);
          End;
          Writeln;
          Writeln('Выполнено');
          Writeln;
          Writeln('Ещё один');
          Writeln('1.Да');
          Writeln('2.Нет');
          Repeat
            Readln(S);
          Until ((S='Нет') Or (S='нет') Or (S='2') Or (S='Да') Or (S='да') Or (S='1'));
          Writeln;
        Until (S='Нет') Or (S='нет') Or (S='2');
        Fin^.Next:=nil;
      End
      Else
      Begin
        If (WhDo='3') Or (WhDo='Найти') Then
        Begin
          Now:=Head^.Next;
          Writeln('Название');
          Repeat
            Readln(S);
          Until Length(S)<>0;
          Flag:=False;
          Search(S, Now, Poftor, Flag);
          If Not Flag Then
            Writeln('Не найдено');
        End
        Else
        Begin
          If (WhDo='4') Or (WhDo='Отсортировать') Then
          Begin
            Writeln('1.По названияю');
            Writeln('2.По статусу');
            Repeat
              Readln(S);
            Until ((S='1') Or (S='По названияю') Or (S='2') Or (S='По статусу'));
            If (S='1') Or (S='По названияю') Then
              SortName:=True
            Else
              SortName:=False;
            Bubl(Head, SortName);
            Writeln('Готово');
          End
          Else
          Begin
            If (WhDo='5') Or (WhDo='Сохранение') Then
            Begin
              Now:=Head^.Next;
              Rewrite(F);
              While Now<>nil Do
              Begin
                Writeln(F, Now^.Name);
                Writeln(F, Now^.Status);
                Now:=Now^.Next;
              End;
              Writeln('Готово');
            End
            Else
            Begin
              If (WhDo='6') Or (WhDo='Выход') Then
                Finish:=True
            End;
          End;
        End;
      End;
    End;
    Writeln;
  Until Finish;

  Writeln('Сохранить');
  Writeln('1.Да');
  Writeln('2.Нет');

  Repeat
    Readln(S);
  Until ((S='Нет') Or (S='нет') Or (S='2') Or (S='Да') Or (S='да') Or (S='1'));
  If (S='Да') Or (S='да') Or (S='1') Then
  Begin
    Now:=Head^.Next;
    Rewrite(F);
    While Now<>nil Do
    Begin
      Writeln(F, Now^.Name);
      Writeln(F, Now^.Status);
      Now:=Now^.Next;
    End;
    Writeln('Готово');
  End;
  CloseFile(F);
End.

