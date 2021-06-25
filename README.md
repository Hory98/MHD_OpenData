# MHD_OpenData

## Introduction
I created minimalist Elm app for showing information about stops in public transport in Prague and neighbor villages. Every stop has 0 to N platforms. Every platform has 0 to N lines. Lines stop on stops. Line has nice icons for type of transport and day/night line signalization. I use data from Prague's opendata website - https://opendata.praha.eu/dataset/zastavky-a-oznacniky-pid .

## Build instruction - Windows
- Use script build.bat for built the app
- The script use command elm make and copy directory with resources (pictures)
- In build directory is prebuild the most current version

## Problems with CORS
I run into problem with 'Access-Control-Allow-Origin' header and I couldn't download JSON with opendata. I found the problem should not be on my side. I read on goverment webside. The website says that websites with opendata should have this access allowed.
https://opendata.gov.cz/%C5%A1patn%C3%A1-praxe:chyb%C4%9Bj%C3%ADc%C3%AD-cors 
As some kind of solution I found this extension for Google Chrome. The extension allow cross domain access and for me it solves the problem. I know that it isn't permanent solution. I added some screenshots if there will be problem with app launching.

## Icons from
https://icons8.com/icon/set/transport/color