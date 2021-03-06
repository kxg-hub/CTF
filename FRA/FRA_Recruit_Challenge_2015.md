***OBS! Jag har inte slutfört denna utmaning***  
FRA_Recruit_Challenge_2015  
Kategori: Nätverksanalys, pentestning och lösenordsforcering.  
[FRA_Recruit_Challenge_2015](https://challenge.fra.se/FRA_Recruit_Challenge_2015.zip)  
(75 MB, 78092299 bytes, sha256: 942668aa12c00ef99907fc59e1e57745b0d7cc4fcb40570ea2f24062fd9c20cc)

## Beskrivning
Testa dina kunskaper i denna flerstegsuppgift. Kunskaper som krävs är nätverksanalys, pentestning och lösenordsforcering. Vi vill ha en rapport där du beskriver lösningen med de lösenord och instruktioner du hittade. Vi är intresserade av din ansökan och rapport även om du inte slutfört alla steg.

### Steg1
Det första jag möts av är en .zip fil som verkar vara lösenordsskyddad samt en readme textfil.

#### Readme
``` 
FRA Recruit Challenge 2015
--------------------------

Hej!

Dr Evil har ett lösenordsarkiv som ligger i ett nästlat träd av komprimerade arkiv som i sin tur är lösenordsskyddade.

Han har under den tid han befunnit sig i sin cryostasis glömt bort lösenordsfraserna till de komprimerade arkiven samt lösenordsarkivet

Problemet är att han under den tid han varit försänkt i sin djupa cryosömn tappat bort alla lösenord till de komprimerade arkiv samt lösenordsarkivet där han lagrar sina lösenord till sina underground lairs and doomsday devices.

Dr Evil har anlitat dig för att återhämta alla lösenord och skriva en rapport som beskriver de steg du utfört, hur du tänkte och hur de olika uppgifterna lösts för att återhämta lösenorden.

Det är därför av största vikt att du dokumenterar alla dina steg, hur du tänkte, vad du har gjort samt lösningen till varje nivå.

Om du har för avsikt att söka jobb hos oss så vill vi att du bifogar en rapport med lösningen och tillvägagångssätt med din ansökan.

I varje nivå finns det lösenordsfrasen till nästa arkiv och nivå men även en eller fler delar till den lösenordsfras som skyddar lösenordsarkivet.

Även om du inte hittar alla lösenord eller låser upp alla nivåer är vi intresserade av att höra hur långt du har kommit och vilka lösenordsfraser du återhämtat.

Första nivån:

Ledtråd - lösenordet finns i klartext...

d1b23a73cd77c23f32256ed204f11469

En ledtråd till kommande nivåer, Dr Evil återanvänder gärna sina lösenord men med lite variationer.
```
Under "Första nivån:" Finns en hash som ser ut som en MD5 hash, en snabb sökning på Google ger direkt lösenordet för att kunna extrahera steg2  
Det är en MD5 hash  
![MD5 hash](https://i.imgur.com/LqGr2vO.png)  
> FRA Recruit Challenge 2015  

##### Lösning 2
MD5 hashen kan knäckas med hjälp av John The Ripper. Ordlistan finns redan eftersom readme-filen ska innehålla lösenordet i klartext..
format=raw-md5
wordlist=readme
```
john --format=raw-md5 readme --wordlist=readme
FRA Recruit Challenge 2015
```
Nu kan steg2 extraheras med hjälp av lösenordet.
### Steg2
steg .zip-filen innehåller en image. För att utforska den monterar jag den i kali linux.
![img](https://i.imgur.com/tSieeGP.png)

Imag-filen innehåller en pdf "FRA-arsrapport-2014" samt .zip steg3.arj. Efter att öppnat pdf-filen och kikat igenom vad som ser ut att vara en helt vanlig årsrapport från FRA gör jag även om den till text (pdftotext) och söker efter olika nyckelord för att se om jag missat något.. Det ger inte någon träff.  
För att kolla om pdfen innehåller något som kan ta oss vidare vad den innehåller.
```
strings FRA-arsrapport-2014.pdf
```
Där hittar jag metadata som verkar lite suspekt.
![img](https://i.imgur.com/o3NXPl1.png)
Det ser ut som hex.  
För att avkoda hex använder jag mig av Decodify(https://github.com/s0md3v/Decodify) som är extremt snabbt och simpelt.
![img](https://i.imgur.com/wD2CrGF.png)
Det gav en base64 rad som i sin tur avkodas till vad som ser ut att vara ett cipher.  
```
dcode "P DPSS OVSK AOL DVYSK YHUZVT MVY AOL ZBT VM VUL MYPJRPU TLLLSSPVU KVSSHYZ" -rot all
```
![img](https://i.imgur.com/dgA3jug.png)
under rot19 ser vi vad som verkar vara lösenordet
> i will hold the world ransom for the sum of one frickin meeellion dollars
Decodify spottar ut output i gemener trots att den matas den versaler.. eftersom en är lat och inte orkar skriva om det till versaler så gör jag det i Python 
```
s = "i will hold the world ransom for the sum of one frickin meeellion dollars"
print(s.upper())
I WILL HOLD THE WORLD RANSOM FOR THE SUM OF ONE FRICKIN MEEELLION DOLLARS

```
Nu kan steg3.arj (som är en .zip, det är en liten luring) extraheras med lösenordet. 
### Steg3
steg3.arj innehåller steg3.pcap samt steg4.rar. Öppnar pcap filen med wireshark, för att enkelt kunna få en överblick så öppnar jag Protocol Hierarchy som finns under fliken Statistics.
Det som spontant ser intressant ut är HTTP, SMB och FTP.  
![img](https://i.imgur.com/vs356y5.png)

En snabb sökning på olika ord "credential,pwd och password" under packet bytes för att se om vi kan få ut något användbart. Password ger oss träffar och under FTP trafiken kan vi se att Dr.Evil har loggat in till sin FTP server med credentials drevil:minime och under FTP-DATA hittar vi vad som skulle kunna bara lösenordet till nästa steg:
![img](https://i.imgur.com/CgbN0F1.png)
```
Del 3 av l.senordsfrasen till l.senordsarkivet, ta bort " kring l.senordet.

"doctor for 30 frickin years"
```
Men "doctor for 30 frickin" funkar verkar inte funka i någon konstellation för att låsa upp steg4. Men vi sparar ner det då det kan komma till användning senare.

Under HTTP ser vi att Dr.Evil läcker NTML credentials.
![img](https://i.imgur.com/o2FwWRv.png)

För att extrahera ntlm hasher från .pcap filen använder jag mig av ett färdigt python script av psychomario(https://github.com/psychomario/ntlmsspparse)

```
::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
:::1122334455667788::
```

Vi minns sedan tidigare ledtråden från readme textfilen
> En ledtråd till kommande nivåer, Dr Evil återanvänder gärna sina lösenord men med lite variationer.

Jag har provat med flera olika ordlistor samt skapat egna men är för närvarande fast här.
![img](https://images.unsplash.com/photo-1533601017-dc61895e03c0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80)
