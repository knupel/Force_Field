peut-être supprimer
public Vec2 get_position() {
return position;
}

le problème doit être là, car la position anlysée n'est pas la position utilisée.
public Vec2 get_position(Force_field ff) { Vec2 temp_pos = position.copy() ; return temp_pos.add(Vec2(ff.canvas_pos)); }

et aussi
Pouvoir activer,désactiver, bronxiser... certaines cases du champs vectoriel, héhéhé ça c'est la bonne idée, enfin on va voir.

Et ne faire fonctionner vehicle qu'avec un object force_field