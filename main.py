import db
from flask import Flask, render_template, request, redirect, url_for, session
from passlib.context import CryptContext

app = Flask(__name__)

@app.route("/")
def launch():
    return redirect(url_for("accueil"))

@app.route("/connexion")
def connexion():
    return render_template("connexion.html")

@app.route("/login", methods = ["post"])
def login():
    password_ctx = CryptContext(schemes=['bcrypt'])
    form_login = request.form.get("Username")
    form_mdp = request.form.get("mdp")
    if not form_login or not form_mdp:
        return redirect(url_for("connexion"))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select login_c, mdp from employe")
            account = cur.fetchall()
    for acc in account:
        if form_login == acc[0] and password_ctx.verify(f'{form_mdp}', f'{acc[1]}'):
            with db.connect() as conn1:
                with conn1.cursor() as cur1:
                    cur1.execute("select id_refuge, nom, prenom from travail natural join employe where login_c = %s", (form_login,))
                    res = cur1.fetchone()
                    print(res)
                    identite = f'{res.nom} {res.prenom}'
            with db.connect() as conn2:
                with conn2.cursor() as cur2:
                    cur2.execute("select nom from refuge")
                    lst_refuges = cur2.fetchall()
            with db.connect() as conn3:
                with conn3.cursor() as cur3:
                    cur3.execute("select nom, espece from animal")
                    lst_animal = cur3.fetchall()
            with db.connect() as conn4:
                with conn4.cursor() as cur4:
                    cur4.execute("select nom, espece, nom_soin from animal NATURAL JOIN vaccination")
                    vaccins = cur4.fetchall()
            return render_template("employe.html", identite = identite, liste_refuges = lst_refuges, liste_animal = lst_animal, lst_vaccination = vaccins)
    return render_template("connexion.html", login = form_login, mdp = form_mdp, bddlogin = acc[0])

@app.route("/accueil")
def accueil():
    return render_template("accueil.html")

@app.route("/espace_client")
def espace_client():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom from refuge")
            lst_refuges = cur.fetchall()
    return render_template("espace_client.html", liste_refuges = lst_refuges)

@app.route("/refuge", methods = ['GET', 'POST'])
def refuge():
    refuge = request.args['refuges']
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select espece, animal.nom, age, sexe, signe_distinctif from animal, refuge where refuge.id_refuge = animal.id_refuge and refuge.nom = %s", (refuge,))
            animaux = cur.fetchall()
    return render_template("refuge.html", pets = animaux)

@app.route("/private")
def private():
    refuge = request.args['refuges']
    with db.connect() as conn2:
        with conn2.cursor() as cur2:
            cur2.execute("select employe.matricule, employe.nom, prenom, employe.adresse, employe.tel, datearriver from employe, travail, refuge where employe.matricule = travail.matricule and refuge.id_refuge = travail.id_refuge and refuge.nom = %s", (refuge,))
            lst_employe = cur2.fetchall()
    return render_template("private.html", liste_employe = lst_employe)

@app.route("/animal", methods = ["post"])
def animal():
    name = request.form.get("nom")
    espece = request.form.get("espece")
    sexe = request.form.get("sexe")
    age = request.form.get("age")
    refuge = request.form.get("refuge")
    if not name or not espece or not sexe or not age or not refuge:
        return render_template("erreur.html")
    signe_distinctif = request.form.get("signe_distinctif")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select id_refuge from refuge where nom = %s", (refuge,))
            id_refuge = cur.fetchone()
    with db.connect() as conn1:
        with conn1.cursor() as cur1:
            if signe_distinctif:
                cur1.execute("insert into animal(espece, nom, age, sexe, signe_distinctif, id_refuge) values (%s, %s, %s, %s, %s, %s)", (espece, name, age, sexe, signe_distinctif, id_refuge,))
            else:
                cur1.execute("insert into animal(espece, nom, age, sexe, id_refuge) values (%s, %s, %s, %s, %s)", (espece, name, age, sexe, id_refuge,))
    with db.connect() as conn2:
        with conn2.cursor() as cur2:
            cur2.execute("select id_animal from animal where nom = %s and espece = %s and sexe = %s and age = %s", (name, espece, sexe, age))
            id_animal = cur2.fetchone()
    with db.connect() as conn3:
        with conn3.cursor() as cur3:
            cur3.execute("insert into historique values (%s, %s, DATE(NOW()))", (id_refuge, id_animal))
    return render_template("animal.html")

@app.route("/soin", methods = ["post"])
def soin():
    nom_animal = request.form.get("nom_animal")
    nom_s = request.form.get("nom_s")
    type_s = request.form.get("type_s")
    date = request.form.get("date")
    matricule = request.form.get("matricule")
    date_rappel = request.form.get("delai_rappel")
    if not nom_animal or not nom_s or not type_s or not date or not matricule:
        return render_template("erreur.html")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select id_animal from animal where nom = %s", (nom_animal,))
            id_animal = cur.fetchone()
    with db.connect() as conn1:
        with conn1.cursor() as cur1:
            if date_rappel:    
                cur1.execute("insert into soin(nom_soin, type_s, date_s, matricule, date_rappel) values (%s, %s, %s, %s, %s)", (nom_s, type_s, date, matricule, date_rappel))
            else:
                cur1.execute("insert into soin(nom_soin, type_s, date_s, matricule) values (%s, %s, %s, %s)", (nom_s, type_s, date, matricule))
    with db.connect() as conn2:
        with conn2.cursor() as cur2:
            cur2.execute("select id_soin from soin where date_s = %s and matricule = %s", (date, matricule))
            id_soin = cur2.fetchone()
    with db.connect() as conn3:
        with conn3.cursor() as cur3:
            cur3.execute("insert into soigne values (%s, %s)", (id_soin,  id_animal))
    return render_template("soin.html")

@app.route("/informations")
def informations():
    animal = request.args["animaux"]
    nom, espece = animal.split(", ")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom_soin, type_s, date_s, matricule from soin NATURAL JOIN soigne NATURAL JOIN animal WHERE nom = %s and espece = %s", (nom,  espece))
            historique_s = cur.fetchall()
    with db.connect() as conn1:
        with conn1.cursor() as cur1:
            cur1.execute("select refuge.nom, date_depart, date_arrivee from historique, animal, refuge where historique.id_animal = animal.id_animal and refuge.id_refuge = historique.id_refuge and animal.nom = %s and animal.espece = %s", (nom,  espece))
            lst_histo = cur1.fetchall()
    return render_template("informations.html", historique_soin = historique_s, nom_animal = nom, espece_animal = espece, historique_transfert = lst_histo)

if __name__ == '__main__':
    app.run(debug=True)
