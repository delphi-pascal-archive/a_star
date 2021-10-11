unit Astar3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, XPMan, StdCtrls, ComCtrls;

type

  TMapCellKind = (mckfloor, mckwall);

  // Donnée d'une case pour le dessin :
  TMapCell = record
    kind: TMapCellKind;
  end;


  // Donnée d'une case pour le calcul du plus court chemin
  // On utilise une classe pour permettre de travailler plus facilement avec des pointeurs et
  // pouvoir faire pointer la cellule vers son parent. Le parent est très important car c'est celui
  // ci qui permet de remonter le chemin une fois l'algorihme terminé.
  TNode = class
  Coup_total : integer   ;
  Coup_esti: integer ;
  Coup_move : integer ;
  Elt_suiv : TNode ;
  Elt_precd : TNode ;
  Parent : TNode ;
  Position : TPoint ;

  Private
   constructor Create();
   procedure Calcul_coup();


  end;

// Les données sont stockées sous forme de liste chainée.
TListe = class
 First : Tnode   ;
 Last : Tnode   ;
 Private
 Constructor Create ()  ;
 Procedure Add(Elt : TNode)   ;
 Function Get (position :TPoint) : TNode  ;
 Procedure Del(Elt : TNode)  ;
 function Smaller(): TNode  ;
 Procedure Clear ()       ;
 Function Vide() : Boolean ;
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Image: TImage;
    XPManifest1: TXPManifest;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Panel2: TPanel;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Label3: TLabel;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    Edit4: TEdit;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    ScrollBar4: TScrollBar;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label6: TLabel;
    Button1: TButton;
    ScrollBar1: TScrollBar;
    Label7: TLabel;
    Edit5: TEdit;
    Button2: TButton;
    Label4: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);

  private
    lmouse_down: boolean;
    mouse_pos: TPoint;
    function Walkable(PtA, PtB : Tpoint) :Boolean ;
    procedure drawMap();
    procedure drawStart();
    procedure drawEnd();
    procedure drawClear;
    procedure drawCells();
    procedure drawCell(x, y: Integer);
    procedure drawWay();
    procedure init();
    procedure cadrillage();
    procedure initLists();
    procedure initImage();
    procedure updateMap();
    procedure ListeFinale();
     function Pointe(elt : Tnode):Tbitmap;
   function  CalcNewNode(parent: TNode; position: TPoint): integer;
   Procedure Deplac_Possible ( Elt : TNode) ;
   Procedure AlgoAStar (  ) ;
   Procedure Smoothing () ;
  public
  end;

var
   H,B,G,D,HD,HG,BD,BG,rien : Tbitmap;
  Form1: TForm1;
  PointA: TPoint;
  PointB: TPoint;

  liste_ouverte: TListe;
  liste_Ferme: TListe;
  liste_finale : Tliste;
  wayfound: boolean;

  elt_actuel, elt_prec : TNode;
  dirX,dirY : Integer;
  dirs,iter : Extended;
  t1t : integer   ;     // T1T = Taiile du Terrain
  T2c :integer ;        // T2c = Taille des carrés
  CELLS_COUNT: integer;
  map: array[0..150] of array[0..150] of TMapCell;
  Debut,Fin:TDateTime;

implementation

{$R *.dfm}


//
// Efface le contenu de l'image en traçant un rectangle de couleur blanche.
procedure TForm1.drawClear;
begin
  with Image.Canvas do
       begin
       Pen.Color := clWhite;
       Brush.Color := Pen.Color;
       Rectangle(0, 0, Image.Width, Image.Height);
       end;
end;


// Dessiner
procedure TForm1.drawMap();
begin
 drawClear();       // Efface le contenu de l'image
 drawCells();
 cadrillage();
  // Dessine le chemin
if wayfound or (not liste_ouverte.Vide)
 then
    begin
      ListeFinale();       //creation d'une derniere liste(3eme) contenant uniquement le chemin
     if radiobutton7.Checked
      then
       begin
        drawWay();
        smoothing();
        Timer1.Enabled := false ;
       end;
     if radiobutton5.Checked
      then
       begin
         drawWay();
         checkBox1.Enabled := true;
        if Checkbox1.Checked
         then
          begin
           timer1.Enabled := true;
           elt_actuel := liste_finale.last;
           elt_prec := elt_actuel;
           dirX := elt_actuel.parent.position.X - elt_prec.position.X;
           dirY := elt_actuel.parent.position.Y - elt_prec.position.Y;
           dirs := sqrt(dirX*dirX + dirY*dirY);
           iter := 1000 ;
          end
         else
          begin
          timer1.Enabled := false ;
          end;
      end;
    if radiobutton6.Checked
     then
      begin
       smoothing;
       checkBox1.Enabled := false ;
       timer1.Enabled := false;
       end;
 end;
  drawstart();
  drawend();

end;


// Dessine les cellules de la carte
procedure TForm1.drawCells();
var
  x, y: integer;
begin
  for x:=0 to CELLS_COUNT-1 do
  for y:=0 to CELLS_COUNT-1 do
     drawCell(x, y);
end;



// Dessine une cellule de la carte

procedure TForm1.drawCell(x, y: Integer);
var
  cell: Tnode;

begin

 with Image.Canvas do
  begin
   font.Size := 1   ;
   font.Color := clblack ;

   if (map[x,y].kind = mckwall)
    then
     begin
      pen.style := psSolid	;
      brush.color := clBlack;
      Rectangle(x*t1t, y*t1t, x*t1t+T2c , y*t1t+T2c );
      brush.Style := bsSolid;
      pen.style := psSolid;
     end
    else
     begin
      cell := liste_ouverte.get(Point(x, y));
      if cell <> nil
      then
        begin
         Pen.Color := $00AAFFFB;
         Brush.Color := Pen.Color;
         Rectangle(x*t1t, y*t1t, x*t1t+T2c , y*t1t+T2c );
         if checkbox2.Checked then
             draw(x*t1t+(t1t div 2 ),y*t1t+(t1t div 2), Pointe(cell));
          if checkbox3.Checked then
              textout(x*t1t+1, y*t1t+2, inttostr(cell.Coup_total) );
        end
     else
      begin
       cell := liste_ferme.get(Point(x, y));
        if cell <> nil
         then
          begin
           pen.Color := $0000D2C8;
           brush.Color := pen.Color;
           Rectangle(x*t1t, y*t1t, x*t1t+T2c , y*t1t+T2c );
           If checkbox2.checked then
             draw(x*t1t+(t1t div 2 ),y*t1t+(t1t div 2 ), pointe(cell));
           if checkbox3.Checked then
             textout(x*t1t+1, y*t1t+ 2, inttostr(cell.Coup_total) );
          end;
      end;
     end;
  end;
end;


// Dessine la case de départ

procedure TForm1.drawStart();
begin
  with Image.Canvas do
       begin

       pen.color := $225522;
       brush.color := $88DD88;
       Rectangle(PointA.x*t1t, PointA.y*t1t, PointA.x*t1t+t2c, PointA.y*t1t+t2c);


       brush.Style := bsClear;
       font.color := $225522;
       textout(PointA.x*t1t+1, PointA.y*t1t+(t1t div 2 ), 'start');
       end;
end;



// Dessine la case d'arrivée

procedure TForm1.drawEnd();
begin
  with Image.Canvas do
       begin

       pen.color := $552222;
       brush.color := $DD8888;
       Rectangle(PointB.x*t1t, PointB.y*t1t, PointB.x*t1t+t2c, PointB.y*t1t+t2c);
       brush.Style := bsClear;
       font.color := $225522;
      textout(PointB.x*t1t+1, PointB.y*t1t+(t1t div 2 ), 'end');
       end
end;


//Ajoute dans une liste supplémentaire contenant uniquement le plus cours chemin,
//Chaque element pointe l'élément suivant dans le parcours
// et non pas le précédent comme dans la liste fermée
procedure TForm1.ListeFinale();
var
elt,parent,Temp2 : Tnode;
  current,bis: TNode;
begin
 bis := nil ;
 liste_finale.clear();
  current := liste_ferme.last;
  temp2:= nil;
   while current <> nil do
    begin
     parent := current.parent;
      if current.parent <> nil
       then
        begin
         bis := TNode.Create  ;
         bis.Parent := temp2;
         bis.Position:= current.Position ;
         Liste_finale.Add(bis);
        end;
     temp2:= bis;
     current := Parent;
    end;
 Elt := TNode.Create ;
 Elt.Position:= PointA ;
 elt.Parent := liste_finale.Last;
 liste_finale.Add(elt);
end;



// Initialisation du programme
procedure TForm1.init;
begin
  // Définition des points de départ et d'arrivée par défaut
  PointA := Point(2, 2);
  PointB := Point(8, 10);

  // Creation de l'image
  initImage();
  // Initialise les listes pour le A*
  initLists();
  // Premier dessin de la carte
  drawMap();
end;


//**************************************************************************************************
// Crée le bitmap de l'image
//**************************************************************************************************
procedure TForm1.initImage;
var
  bitmap: TBitmap;

begin
  bitmap := TBitmap.Create();
  bitmap.Width := Image.Width;
  bitmap.Height := Image.Height;
  Image.Picture.Assign(bitmap);
  bitmap.Free;


  Image.Parent.DoubleBuffered := true;
end;



// Initialise les listes pour le A* : une liste ouverte,une liste fermée,
// etune liste pour le chemin

procedure TForm1.initLists();
begin
liste_finale := Tliste.Create ;
liste_ouverte := TListe.Create;
liste_ferme := TListe.Create;

end;



// Appelé lors d'un clic de souris ou d'un déplacement sur la carte pour mettre a jour les infos.

procedure TForm1.updateMap;
begin
 if RadioButton3.Checked   // Si l'outil est l'ajout de murs
  then
   begin
    map[mouse_pos.X, mouse_pos.Y].kind := mckwall;
    AlgoAstar();
    drawMap();
   end
 else
  if RadioButton4.Checked
   then   // Si l'outil est sol
    begin
     map[mouse_pos.X, mouse_pos.Y].kind := mckfloor;
     AlgoAstar();
     drawMap();
    end
   else
    if RadioButton1.Checked    // Si l'outil est la position du point de départ
     then
      begin
       if map[mouse_pos.X, mouse_pos.Y].kind = mckFloor
        then
         begin
          PointA := mouse_pos;
          AlgoAstar();
          drawMap();
         end;
       end
      else
     if RadioButton2.Checked  // Si l'outil est la position du point d'arrivé
      then
       begin
        if map[mouse_pos.X, mouse_pos.Y].kind = mckFloor
         then
          begin
           PointB:= mouse_pos;
           AlgoAstar;
           drawMap();
          end;
      end;
end;



// Début de l'algorithme de recherche du plus court chemin

procedure TForm1.AlgoAstar();
var
Elt : TNode ;
NextElt : Tnode ;
Stop : Boolean ;
begin
 Debut := Now;
 wayfound := false;
 Liste_ferme.Clear ()   ;
 Liste_Ouverte.Clear() ;
 Liste_finale.Clear() ;

 Elt := TNode.Create ;
 Elt.Position:= PointA ;
 Elt.Calcul_coup();
 Liste_Ferme.Add(Elt);

 stop := False ;
 While Stop = false do
  begin
   Deplac_possible(Elt)  ;
    If not Liste_ouverte.Vide
     then
      Begin
       nextelt := Liste_ouverte.Smaller();
       If (nextelt.Position.X = PointB.X) and (nextelt.Position.Y = PointB.Y)
        then
         begin
          Wayfound := true ;
          Stop := true ;
         end ;
       Liste_Ouverte.Del(nextelt);
       Liste_Ferme.Add(nextelt);
       elt := nextelt;
      end
     else
      begin
       Stop := true ;
      end;
     if wayfound
      then
       begin
       label2.Caption := 'Founded path - length: '
       +inttostr( liste_ferme.last.Coup_move );
       end
      else
       begin
        label2.Caption := 'Path not found';
       end;

  end;
end;


// toutes les cases autour d'une case.
Procedure TForm1.Deplac_Possible ( Elt : TNode) ;


Begin

CalcNewNode(Elt, Point( Elt.Position.X ,elt.Position.Y+1));
CalcNewNode(Elt, Point (Elt.Position.X ,elt.Position.Y-1));
CalcNewNode(Elt, Point(Elt.Position.X+1 ,elt.Position.Y));
CalcNewNode(Elt, Point (Elt.Position.X-1 ,elt.Position.Y));

 If   (map[Elt.Position.X ,elt.Position.Y+1].kind <> mckwall)  and
      (map[Elt.Position.X ,elt.Position.Y-1].kind <> mckwall)  and
      (map[Elt.Position.X+1 ,elt.Position.Y].kind <> mckwall)  and
      (map[Elt.Position.X-1 ,elt.Position.Y].kind <> mckwall)
Then
  begin
CalcNewNode(Elt, Point( Elt.Position.X+1 ,elt.Position.Y+1));
CalcNewNode(Elt, Point (Elt.Position.X+1 ,elt.Position.Y-1));
CalcNewNode(Elt, Point(Elt.Position.X-1,elt.Position.Y+1));
CalcNewNode(Elt, Point (Elt.Position.X-1 ,elt.Position.Y-1));
 end;
end;

//**************************************************************************************************
// Ajoute la cellule si elle n'y est pas déjà dans la liste ouverte et renvoi le prix de trajet.
//**************************************************************************************************
function TForm1.CalcNewNode(parent: TNode; position: TPoint): integer;
var
Elt : TNode ;
tempelt : Tnode ;
Resultat : integer ;
begin
Resultat := -1;

 if (position.X >= 0) and (position.X < CELLS_COUNT)
  and(position.Y >= 0) and (position.Y < CELLS_COUNT)
  and(map[position.X, position.Y].kind<>mckwall)
  and(liste_ferme.get(position) = nil)
 then
  begin
   elt := liste_ouverte.get(position);
  if  Elt = nil
   then
    begin
     Elt := Tnode.Create ;
     Elt.Parent := Parent ;
     Elt.Position := Position ;
     Elt.Calcul_Coup() ;
     Liste_Ouverte.Add(Elt);
    end
  Else
   begin
    tempelt := TNode.Create;
    tempelt.position := position;
    tempelt.parent := parent;
    tempelt.Calcul_coup;
     if tempelt.Coup_move< elt.Coup_move
      Then
       begin
       elt.Parent := Parent;
       elt.Calcul_coup();
       end;
    tempelt.Free ;
    end;
   Resultat := Elt.Coup_total;
  end;
 CalcNewNode := Resultat ;
end;

//**************************************************************************************************
// Appelé lorsque la fenetre est crée. On initialise les données du programme.
//**************************************************************************************************
procedure TForm1.FormCreate(Sender: TObject);
begin
t1t := 25 ;
t2c :=  25;
cells_count := 20;
  Init();
   H:= TBitmap.Create();    HD:= TBitmap.Create();
   B:= TBitmap.Create();     HG:= TBitmap.Create();
    G:= TBitmap.Create();    BG:= TBitmap.Create();
     D:= TBitmap.Create();    BD:= TBitmap.Create();
     rien := Tbitmap.create();
B.LoadFromFile('bas.bmp');
BD.LoadFromFile('basdroite.bmp');
BG.LoadFromFile('basgauche.bmp');
H.LoadFromFile('haut.bmp');
D.LoadFromFile('droite.bmp');
G.LoadFromFile('gauche.bmp');
HD.LoadFromFile('hautdroite.bmp');
HG.LoadFromFile('hautgauche.bmp');
Rien.LoadFromFile('rien.bmp');
scrollbar3.Enabled := false ;

end;



//**************************************************************************************************
// Appui sur l'un des boutons de la souris.
//**************************************************************************************************
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     begin
     lmouse_down := true;

     updateMap;
     end;
end;


//**************************************************************************************************
// Mouvement de la souris au dessus de l'image.
//**************************************************************************************************
procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // On teste si la case pointée par le curseur a changé, sinon il n'est pas nécessaire de mettre à
  // jour la carte.
  if ((mouse_pos.X <> X div t1t) or (mouse_pos.Y <> Y div t1t)) then
     begin
     mouse_pos := Point( X div t1t, Y div t1t );

     // On vérifi que la position du curseur reste dans la carte
     if mouse_pos.X < 0 then mouse_pos.X := 0;
     if mouse_pos.X > CELLS_COUNT-1 then mouse_pos.X := CELLS_COUNT-1;
     if mouse_pos.Y < 0 then mouse_pos.Y := 0;
     if mouse_pos.Y > CELLS_COUNT-1 then mouse_pos.Y := CELLS_COUNT-1;

     // Si le bouton gauche de la souris est appuyé on met à jour la carte.
     if lmouse_down then
        begin
        updateMap();
        end;
     end;
end;


//**************************************************************************************************
// Relachement de l'un des boutons de la souris
//**************************************************************************************************
procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     begin
     lmouse_down := false;
     end;
end;


//**************************************************************************************************
// Constructeur AStarCell.
// Initialise les pointeurs de liste chainée à nil.
//**************************************************************************************************
constructor TNode.Create();
begin
  parent := nil;
  Elt_suiv := nil;
  Elt_precd := nil;
end;


//**************************************************************************************************
// Calcul du prix de déplacement
//**************************************************************************************************
procedure TNode.Calcul_coup() ;

begin
If Parent <> nil
 then
  begin
   if  ((position.X = parent.position.X+1 )or( position.X = parent.position.X-1))
    and ((position.Y = parent.position.Y+1) or(position.Y = parent.position.Y-1))
    then
     coup_move := parent.coup_move +14
    else
     coup_move := parent.coup_move +10;
  end
 else
  coup_move := 0 ;
  coup_esti :=  abs( PointB.X - position.X )*10 + abs( PointB.Y - position.Y ) *10;
  coup_total:= coup_esti + coup_move ;
end;


constructor TListe.Create();
begin
  first := nil;
  last := nil;
end;


Procedure TListe.Add(Elt : TNode);
begin
if First <> nil
 then
  begin
   last.elt_suiv := elt ;
   Elt.Elt_precd:= last ;
   elt.elt_suiv := nil ;
   Last := Elt;
  end
 else
  begin
   First := Elt ;  //liste vide
   Last := Elt  ;
  end;
end;


procedure Tliste.Del(Elt : TNode);
begin
 If Elt.Elt_precd <> nil
  then
   begin
    Elt.Elt_precd.Elt_suiv := Elt.Elt_suiv
   end
 Else
  begin
   First := Elt.Elt_suiv ;
  end;

 If  Elt.Elt_suiv <> nil
  then
   begin
    Elt.Elt_suiv.Elt_precd := Elt.Elt_precd  ;
  end
 Else
  begin
   Last := Elt.Elt_precd ;
  end;
end;




// Renvoi la cellule en fonction de la position, renvoi nil si elle n'existe pas.

Function TListe.Get(position : TPoint): TNode ;
Var
Elt : TNode ;
resultat : TNode ;
begin
Resultat := nil;
Elt := First;
While (resultat=nil)and( Elt<>nil) do
 begin
  if (elt.position.X = position.X) and (elt.position.Y = position.Y)
   then
    begin
     resultat := elt
    end
   else
    begin
     Elt := Elt.Elt_suiv ;
    end;
 end;
Get := resultat ;
end;




// Renvoi la cellule qui a le plus faible cout.

Function  Tliste.Smaller () : TNode ;
var
Valeur : integer   ;
Elt,Elt_petit : TNode ;
begin
Valeur := -1;
Elt_petit := nil   ;
Elt := First ;
 While Elt <> nil do
  begin
   If (Elt.Coup_total < Valeur) or (valeur =-1)
    then
     begin
      Valeur := elt.Coup_total ;
      elt_petit := elt ;
     end;
      Elt := Elt.Elt_suiv;
  end;
smaller := Elt_petit;
end;


// Renvoi true si la liste est vide

Function TListe.Vide() : Boolean ;
begin
Vide := first = nil;
 end;



Procedure TListe.Clear() ;
var
Elt : TNode ;
next : Tnode;
Begin
Elt := First ;
 While Elt <> nil do
  begin
   next := elt.elt_suiv;
   Elt.Free;
   elt := next ;
  end;
first := nil;
last := nil;
end;

//Random des murs
procedure TForm1.Button1Click(Sender: TObject);
var
i : integer ;
begin
for i:= 0 to scrollbar1.Position do
 begin
  map[random(cells_count),random(cells_count)].kind := mckwall ;
end;
 end;

//permet de faire bouger le ptit carré (écrit par Florent)
procedure TForm1.Timer1Timer(Sender: TObject);
var
varX,varY : Integer;
begin
 with Image.Canvas do
  begin
   pen.Width := 2;
   varX := dirX * Round(iter);
   varY := dirY * Round(iter);
   if elt_actuel <> nil
    then
     begin
      Pen.Color := clWhite;
      Brush.Color := Pen.Color;
      Rectangle(elt_prec.position.x*t1t + varX - dirX, elt_prec.position.y*t2c + varY - dirY,
      elt_prec.position.x*t1t+t2c + varX - dirX, elt_prec.position.y*t1t+t2c + varY - dirY);
      pen.Color := clgreen;
      brush.color := clgreen;
      Rectangle(elt_prec.position.x*t1t + varX, elt_prec.position.y*t1t + varY,
      elt_prec.position.x*t1t+t2c + varX, elt_prec.position.y*t1t+t2c + varY);
      if iter >= t1t
       then
        begin
         iter := 0;
         elt_prec := elt_actuel;
         elt_actuel := elt_actuel.Parent;
         if elt_actuel <> nil
          then
           begin
             dirX := elt_actuel.position.X - elt_prec.position.X;
             dirY := elt_actuel.position.Y - elt_prec.position.Y;
             dirs := sqrt(dirX*dirX + dirY*dirY);
           end;
        end
       else
        begin
          iter := iter + 1.0 / dirs;
         end;
     end;
   pen.Width := 1;
  end;
end;



//Fonction permettant de savoir si il ya un mur sur le segment entre 2 points
//utilise les coordonnés et le cooeficient directeur de la droite pour me déplacr
// . Retourne vrai si il n'y a pas de mur.
function Tform1.Walkable(PtA, PtB : Tpoint) :Boolean ;
 var
i ,GrandX,PetitX,Petity,Grandy: integer;
iY,iX ,gram,grad :integer;
a,b: extended ;
resultat : Boolean;
 begin
  If pta.X > ptb.X
   then
    begin
      GrandX := pta.x ;
      PetitX := Ptb.x ;
    end
   else
    begin
     Grandx := Ptb.x;
     petitx := pta.x;
    end ;
  if pta.y>ptb.Y
   then
    begin
      Grandy := pta.y ;
      Petity := Ptb.y ;
    end
   else
    begin
     Grandy := Ptb.y;
     petity := pta.y;
    end;
     If pta.x = ptb.X
      then
       begin
        a := 0;
       end
      else
       begin
        a := (pta.y - ptb.y)/(pta.X - ptb.X);
       end;

  b:= pta.Y - a*pta.X;
  resultat := false;
  if (ptA.y <> PtB.y)and (ptA.x <> PtB.x)
   then
    begin
     while petitx <> GrandX do
      begin
       IX := petitx;
       Iy := round(IX*a + b) ;
       petitx := petitx+1 ;
       if (map[IX,iy].kind <> mckWall)
        then
         begin
          resultat := true;
         end
        else
         begin
          resultat := false ;
          break;
         end;
      end;
    end;

  If resultat then
    begin
     while petity <> Grandy do
      begin
       Iy := petity;
       Ix := round((Iy-b)/a) ;
       petity := petity+1 ;
       if (map[IX,iy].kind <> mckWall)
        then
          begin
           resultat := true;
          end
         else
          begin
           resultat := false ;
           break;
          end;
      end;
 end;
Walkable := resultat;
end;


// une fois que l'on connais le chemin.
//Checkpoint Point de départ, currentPoint est le point a supprimer si possible.

Procedure Tform1.Smoothing();
var
CheckPoint , bis ,way,
CurrentPoint, Temp  : TNode;
Begin

Checkpoint := Liste_finale.Last ;
CurrentPoint := checkpoint.Parent;
temp := nil;
 While currentPoint.parent <> nil do
  begin
   if Walkable(checkPoint.Position, currentPoint.Parent.Position) then
     begin
      temp := currentPoint;
      CurrentPoint := CurrentPoint.Parent;
      way := Liste_finale.Get(temp.Position);
      way.Elt_suiv.Parent := way.Parent;
      Liste_finale.Del(way);
     end
  else
   begin
    checkpoint := currentPoint ;
    currentPoint:= currentPoint.Parent;
   end;
  end;
drawWay();
end;



//Derniere étape : Dessiner le chemin
procedure TForm1.drawWay();
var
current: TNode;

Begin
 with Image.Canvas do
  begin
   if radiobutton5.Checked
    then
      begin
       pen.Color := clRed;
       pen.Width := 2;
      end  ;
   if radiobutton6.Checked
    then
     begin
      pen.Color := $005F29FE;
      pen.Width := 2;
     end;
   If radiobutton7.Checked
    then
     begin
      pen.Color := clblue;
      pen.Width := 2;
     end;
   current :=  liste_finale.last;
   while current <> nil do
    begin
     if current.parent <> nil
      then
       begin
        moveto( current.position.X *t1t+(t1t div 2) , current.position.Y *t1t+(t1t div 2) );
        lineto( current.parent.position.X *t1t +(t1t div 2), current.parent.position.Y *t1t +(t1t div 2));
       end;
     current := current.Parent;
    end;

 pen.Width := 1;
 fin := Now;
 edit4.text:=('Calculate at: '+FormatDateTime('HH:NN:SS:ZZZZZ',Fin-Debut));
 end;
end;


procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
T1T := scrollbar2.Position  ;
T2C := ScrollBar2.Position ;
edit1.Text:= IntToStr(scrollbar2.Position)  ;
If scrollBar2.Position < 20 then
 begin
  checkbox2.Checked := false ;
  checkbox2.Enabled := false ;
     checkbox3.Checked := false ;
  checkbox3.Enabled := false ;
 end
else
   begin
  checkbox2.Enabled := enabled ;

  checkbox3.Enabled := enabled ;
end;
end;
procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
T2C := scrollbar3.Position  ;
edit2.Text := IntToStr(scrollbar3.Position);
end;

procedure TForm1.ScrollBar4Change(Sender: TObject);
begin
scrollbar1.Max := (scrollbar4.Position *  scrollbar4.Position) div 2 ;
cells_count := scrollbar4.Position  ;
edit3.Text:= IntToStr(scrollbar4.Position)  ;
end;

procedure TForm1.cadrillage();
var
x,y : integer ;
begin
with image.Canvas do
  begin
   for x:=0 to cells_count do
    begin
          Pen.Color := clblack;
      pen.style := psSolid	;
          brush.color := clblack;
           moveto(x*t2c,0*t2c);
     lineto(x*t2c,cells_count*t2c);
   end;
    for y:=0 to cells_count do
    begin
      pen.style := psSolid	;
        Brush.Color := Pen.Color;

           moveto(0,y*t2c);
     lineto(cells_count*t2c,y*t2c);
  end;
end;
end;


//Permet de savoir vers qui pointe chaque case
function TForm1.Pointe(elt : Tnode) : Tbitmap;
var
resultat: Tbitmap;
begin
resultat  := Tbitmap.Create ;
If elt.parent <> nil then   begin
  If ((elt.Parent.Position.x+1) = (elt.Position.X ))
      and ((elt.Parent.Position.Y) = (elt.Position.Y))
      then
       begin
        resultat := G;
       end;
    If ((elt.Parent.Position.x-1) = (elt.Position.X ) )
      and ((elt.Parent.Position.Y) = (elt.Position.Y) )
      then
       begin
        resultat := D;
       end;
        If ((elt.Parent.Position.x) = (elt.Position.X ))
      and ((elt.Parent.Position.Y-1) = (elt.Position.Y))
      then
       begin
        resultat := B;
       end;
        If ((elt.Parent.Position.x) = (elt.Position.X ))
      and ((elt.Parent.Position.Y+1) = (elt.Position.Y) )
      then
       begin
        resultat := H;
       end;

        If ((elt.Parent.Position.x+1) = (elt.Position.X ))
      and ((elt.Parent.Position.Y-1) = (elt.Position.Y))
      then
       begin
        resultat := BG;
       end;
    If ((elt.Parent.Position.x-1) = (elt.Position.X ) )
      and ((elt.Parent.Position.Y+1) = (elt.Position.Y) )
      then
       begin
        resultat := HD;
       end;
        If ((elt.Parent.Position.x-1) = (elt.Position.X ))
      and ((elt.Parent.Position.Y-1) = (elt.Position.Y))
      then
       begin
        resultat := BD;
       end;
        If ((elt.Parent.Position.x+1) = (elt.Position.X ))
      and ((elt.Parent.Position.Y+1) = (elt.Position.Y) )
      then
       begin
        resultat := HG;
       end;

       pointe := resultat;
   end
   else
   pointe := Rien
 end;

//Efface tous les murs
procedure Tform1.Button2Click(Sender: TObject);
var
i,j : integer ;
begin
for i := 0 to cells_count-1 do
for j := 0 to cells_count-1 do
map[i,j].kind := mckFloor ;
end;




procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
edit5.Text := IntTOStr(scrollbar1.Position);
end;

end.

