--QUERY
/*Creare una vista che presenta la lista di tutti i dipendenti con le seguenti informazioni: 
stato e agenzia di lavoro,mansione, ruolo, contratto e stipendio di ognuno.  
Da questa vista possono essere fatte varie query.*/
DROP VIEW IF EXISTS Stato_Dipendente CASCADE;
CREATE VIEW Stato_Dipendente (Stato, Agenzia, Dipendente, Mansione, Ruolo, Contratto, Stipendio) AS
SELECT A.Stato, A.Codice as Agenzia, D.Codice as Dipendente, D.Mansione, D.Ruolo, P.Contratto, P.Stipendio
FROM Agenzia A, Dipendente D, Dati_Personali P  
WHERE A.Codice=D.Sede AND D.Codice=P.Codice_dip
ORDER BY A.Stato ASC, A.Codice ASC;

--N.1a) Contare per stato quante agenzie ci sono
SELECT Stato,  COUNT(*) as Agenzie
FROM Stato_Dipendente
GROUP BY Stato;

--N.1b)Contare per stato quanti dipendenti sono venditori, quanti assistenti e quante guide turistiche
SELECT Stato, Mansione, COUNT(*)
FROM Stato_Dipendente
WHERE Mansione='venditore' or Mansione='guida turistica' or Mansione='assistente' 
GROUP BY Stato, Mansione;

--N.1c) Contare per stato quanti dipendenti sono a tempo indeterminato quanti stagisti e quanti a chiamata
SELECT Stato, Contratto, COUNT(*)
FROM Stato_Dipendente
WHERE Contratto='indeterminato' or Contratto='stagista' or Contratto='a chiamata'
GROUP BY Stato, Contratto
ORDER BY Stato DESC;

--N.1d) Fornire la media degli stipendi, il minimo e il massimo per ogni stato
SELECT Stato, AVG(Stipendio) as Media_Stipendi, MIN(Stipendio) as Min_stipendio, MAX(Stipendio) as Max_stipendio
FROM Stato_Dipendente
GROUP BY Stato
ORDER BY AVG(Stipendio) DESC;

--N.2 query n. 1d) fatta senza usare la vista
--Fornire la media degli stipendi, il minimo e il massimo per ogni stato
SELECT Agenzia.Stato, AVG(Dati_Personali.Stipendio) as Media_Stipendi, MIN(Stipendio) as Min_stipendio, MAX(Stipendio) as Max_stipendio
FROM (Dati_Personali JOIN Dipendente on Dati_Personali.Codice_dip=Dipendente.Codice) JOIN Agenzia on Dipendente.Sede=Agenzia.Codice
GROUP BY Agenzia.Stato
ORDER BY AVG(Dati_Personali.Stipendio) DESC;

--N.3  I 3 stati più scelti per i viaggi
SELECT Stato, COUNT(*) AS Viaggi
FROM Vendita JOIN Viaggio ON Vendita.Codice_viaggio=Viaggio.Codice
GROUP BY Viaggio.Stato
ORDER BY Viaggi DESC
LIMIT 3;

--N.4 Elenco dei viaggi senza mezzi di trasporto a disposizione
SELECT Nome, Stato, Citta
FROM Viaggio
WHERE Citta NOT IN
		(SELECT D_Citta
		 FROM Mezzo_Trasporto
		 UNION
		 SELECT P_Citta
		 FROM Mezzo_Trasporto
		);

--N.5 n° viaggi venduti da un dipendente e mostrare i dipendenti con almeno 5 viaggi venduti nel 2019-2020
SELECT Dipendente.Codice, COUNT(*) AS Vendite
FROM Vendita, Dipendente 
WHERE Vendita.Codice_dip=Dipendente.Codice AND Vendita.Data>'2019-01-01'
GROUP BY Dipendente.Codice
HAVING COUNT(Dipendente.Codice)>=5 
ORDER BY Vendite DESC;

--N.6 Elenco dei clienti stranieri (Stato ≠ Italia) che hanno prenotato un viaggio a Venezia con alloggio in hotel da 4 o 5 stelle
SELECT  C.Cognome, C.Nome, A.Data as Data_acquisto
FROM Cliente as C,Vendita as A, Viaggio as V, Alloggio as S
WHERE C.PI_CF=A.Cliente AND A.Codice_viaggio=V.Codice AND A.Codice_alloggio=S.Codice 
	AND C.Stato<>'Italia' AND V.Citta='Venezia' AND S.Tipologia='hotel' AND (S.Categoria='5' or S.Categoria='4')
ORDER BY A.Data, C.Stato;
