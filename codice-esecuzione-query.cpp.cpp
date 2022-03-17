#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"
#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_DB "Agenzia_Viaggi_Girovagando"
#define PG_PASS "basiSQL"
#define PG_PORT 5432
using namespace std ;

 void checkResults ( PGresult * res , const PGconn * conn ) {
 if ( PQresultStatus ( res ) != PGRES_TUPLES_OK ) {
 cout << " Risultati inconsistenti !" << PQerrorMessage ( conn ) << endl ;
 PQclear ( res );
 exit (1) ;
 }
 }


int main (){
	char conninfo[250];
	sprintf(conninfo, "hostaddr=%s user=%s dbname=%s password=%s port=%d",
			PG_HOST, PG_USER, PG_DB, PG_PASS, PG_PORT);
	PGconn*conn;
	conn=PQconnectdb(conninfo);
	if(PQstatus(conn)!= CONNECTION_OK){
		cout<<"Errore di connessione "<<PQerrorMessage(conn);
		PQfinish(conn);
	}
	else{cout<<"Connessione avvenuta correttamente"<<endl;}

PGresult * res ;
int tuple;
int campi;
//query n.1a)
cout<<"Query N.1a)"<<endl;
res = PQexec ( conn , "SELECT Stato,  COUNT(*) as Agenzie FROM Stato_Dipendente GROUP BY Stato;");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.1b)
cout<<"Query N.1b)"<<endl;
res = PQexec ( conn , "SELECT Stato, Mansione, COUNT(*) FROM Stato_Dipendente WHERE Mansione='venditore' or Mansione='guida turistica' or Mansione='assistente' GROUP BY Stato, Mansione;");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.1c)
cout<<"Query N.1c)"<<endl;
res = PQexec ( conn , "SELECT Stato, Contratto, COUNT(*) FROM Stato_Dipendente WHERE Contratto='indeterminato' or Contratto='stagista' or Contratto='a chiamata' GROUP BY Stato, Contratto ORDER BY Stato DESC; ");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.1d)
cout<<"Query N.1d)"<<endl;
res = PQexec ( conn , "SELECT Stato, AVG(Stipendio) as Media_Stipendi, MIN(Stipendio) as Min_stipendio, MAX(Stipendio) as Max_stipendio FROM Stato_Dipendente GROUP BY Stato ORDER BY AVG(Stipendio) DESC;");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.2
cout<<"Query N.2"<<endl;
res = PQexec ( conn , "SELECT Agenzia.Stato, AVG(Dati_Personali.Stipendio) as Media_Stipendi, MIN(Stipendio) as Min_stipendio, MAX(Stipendio) as Max_stipendio FROM (Dati_Personali JOIN Dipendente on Dati_Personali.Codice_dip=Dipendente.Codice) JOIN Agenzia on Dipendente.Sede=Agenzia.Codice GROUP BY Agenzia.Stato ORDER BY AVG(Dati_Personali.Stipendio) DESC;");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.3
cout<<"Query N.3"<<endl;
res = PQexec ( conn , "SELECT Stato, COUNT(*) AS Viaggi FROM Vendita JOIN Viaggio ON Vendita.Codice_viaggio=Viaggio.Codice GROUP BY Viaggio.Stato ORDER BY Viaggi DESC LIMIT 3;"); 
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.4
cout<<"Query N.4"<<endl;
res = PQexec ( conn , "SELECT Nome, Stato, Citta FROM Viaggio WHERE Citta NOT IN (SELECT D_Citta FROM Mezzo_Trasporto UNION SELECT P_Citta FROM Mezzo_Trasporto);");
		checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.5
cout<<"Query N.5"<<endl;
res = PQexec ( conn , "SELECT Dipendente.Codice, COUNT(*) AS Vendite FROM Vendita, Dipendente WHERE Vendita.Codice_dip=Dipendente.Codice AND Vendita.Data>'2019-01-01' GROUP BY Dipendente.Codice HAVING COUNT(Dipendente.Codice)>=5  ORDER BY Vendite DESC; ");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;

//query n.6
cout<<"Query N.6"<<endl;
res = PQexec ( conn , "SELECT C.Cognome, C.Nome, A.Data as Data_acquisto FROM Cliente as C,Vendita as A, Viaggio as V, Alloggio as S WHERE C.PI_CF=A.Cliente AND A.Codice_viaggio=V.Codice AND A.Codice_alloggio=S.Codice AND C.Stato<>'Italia' AND V.Citta='Venezia' AND S.Tipologia='hotel' AND (S.Categoria='5' or S.Categoria='4') ORDER BY A.Data, C.Stato; ");
checkResults ( res , conn );
tuple = PQntuples ( res ) ;
campi = PQnfields ( res ) ;
// Stampo intestazioni
for ( int i = 0; i < campi ; ++ i){
printf("%-20s",PQfname ( res ,i));
}
cout << endl ;
// Stampo i valori selezionati
for ( int i = 0; i < tuple ; ++ i ){
for ( int j = 0; j < campi ; ++ j){
printf("%-20s",PQgetvalue ( res , i , j ));
}
cout << endl ;
}
cout<<endl;


PQclear ( res );
PQfinish ( conn );
}
