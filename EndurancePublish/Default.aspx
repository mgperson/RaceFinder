<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Endurance Race Finder</title>
    <link type="text/css" rel="stylesheet" href="Inc/Styles.css"/>
    <script type="text/javascript" src="Inc/jquery-1.11.0.min.js"></script>           
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=true">
        
    </script>
    
    <script type="text/javascript">
        var lat = "";
        var long = "";
        var map = "";
        navigator.geolocation.getCurrentPosition(success);        
        var curRace = 0;
        var markers = [];


        function SendAjax(webPageName, queryParams, triggerFunction) {           

            queryParams = queryParams.replace(/%26%23/g, '%26 %23');
            queryParams = queryParams.replace(/%23%26/g, '%23 %26');

            var date = new Date();
            var unique = date.getDay() + date.getHours() + date.getMinutes() + date.getSeconds() + date.getMilliseconds();

            var dataObject = {
                uniqueParameters: unique,
                queryParameters: queryParams
            };
            $.ajax(
            {
                type: "POST",
                url: webPageName,
                //data: dataObject,
                data: queryParams + '&' + unique,
                success: triggerFunction
            });
        }

        function success(position) {
            lat = position.coords.latitude;
            long = position.coords.longitude;            
        }

        function SearchRaces() {
            $("#race" + curRace + "").hide();
            curRace = 0;
            var categoryType = $('#selectValue option:selected').text();

            arguments = 'method=SearchRaces&category=' + categoryType + '&lat=' + lat + '&long=' + long;            
            SendAjax('BackgroundProcess.aspx', arguments, SearchRacesTriggered);
        }

        function GetPreviousRace() {
            var marker = markers[curRace];
            marker.setMap(null);
            $("#race" + curRace + "").hide();
            curRace = curRace - 1;
            if (curRace == -1) curRace = 0;
            $("#race" + curRace + "").show();

            AddMapMarker(curRace);
        }

        function GetNextRace() {
            markers[curRace].setMap(null)
            $("#race" + curRace + "").hide();
            curRace = curRace + 1;
            $("#race" + curRace + "").show();

            AddMapMarker(curRace);
        }

        function AddMapMarker(curRace) {
            var latitude = $('#latitude' + curRace).text();
            var longitude = $('#longitude' + curRace).text();
            var categoryType = $('#selectValue option:selected').text();

            var coords = new google.maps.LatLng(latitude, longitude);

            var marker = new google.maps.Marker({
                position: coords,
                map: map,
                title: categoryType
            });

            markers[curRace] = marker;
        }

        function SearchRacesTriggered(response) {
            if(markers[curRace] != null) markers[curRace].setMap(null);
            $("#divRaceResults").html(response);
            $("#race0").show();

            AddMapMarker(0);
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
    <div class="mainSection">                    
        <h1>Endurance Race Finder</h1>
        <div id="divCurrentLocation">              
            <h2>Location:</h2>
            <article>

    </article>
        </div>
        <div id="divSearching">
            <div><h2>Select a race category to search for:</h2></div>
            <select id="selectValue">
                <option value="Marathon">Marathon</option>
                <option value="Half-Marathon">Half-Marathon</option>
                <option value="Triathlon">Triathlon</option>
                <option value="5k">5k</option>
                <option value="10k">10k</option>
                <option value="Ironman">Ironman</option>
            </select>
            <input type="button" onclick="SearchRaces();" value="Search races" />
            <span id="txtTest" runat="server" />
        </div>
        <div id="divRaces">
            <div id="divRaceResults">
                Click 'Search races' to find a race near your current location!
            </div>
            <input type="button" value="<" onclick="GetPreviousRace();" />
            <input type="button" value=">" onclick="GetNextRace();" />            
        </div>
    </div>
        <section id="wrapper">   
<script>
    function success(position) {
        var mapcanvas = document.createElement('div');
        mapcanvas.id = 'mapcontainer';
        mapcanvas.style.height = '300px';
        mapcanvas.style.width = '300px';

        document.querySelector('article').appendChild(mapcanvas);

        var coords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

        var options = {
            zoom: 7,
            center: coords,
            mapTypeControl: false,
            navigationControlOptions: {
                style: google.maps.NavigationControlStyle.SMALL
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("mapcontainer"), options);

        var marker = new google.maps.Marker({
            position: coords,
            map: map,
            title: "You are here!"
        });
    }

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(success);
    } else {
        error('Geo Location is not supported');
    }

</script>
</section>
    </form>
</body>
</html>
