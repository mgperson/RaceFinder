<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Endurance Race Finder</title>
    <link type="text/css" rel="stylesheet" href="Inc/Styles.css"/>
    <script type="text/javascript" src="Inc/jquery-1.11.0.min.js"></script>           
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=true">
        
    </script>
    <article>

    </article>
    <script type="text/javascript">
        var lat = "";
        var long = "";
        navigator.geolocation.getCurrentPosition(success);        
        var curRace = 0;


        function SendAjax(webPageName, queryParams, triggerFunction) {
            //alert(webPageName);            
            //queryParams = encodeURIComponent(queryParams);

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
            $("#race" + curRace + "").hide();
            curRace = curRace - 1;
            if (curRace == -1) curRace = 0;
            $("#race" + curRace + "").show();
        }

        function GetNextRace() {
            $("#race" + curRace + "").hide();
            curRace = curRace + 1;
            $("#race" + curRace + "").show();
        }

        function SearchRacesTriggered(response) {
            $("#divRaceResults").html(response);
            $("#race0").show();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>                    
        <div id="divCurrentLocation">  
            Current Location          
        </div>
        <div id="divSearching">
            <div>Please select a race category to search for.</div>
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
        mapcanvas.style.height = '200px';
        mapcanvas.style.width = '200px';

        document.querySelector('article').appendChild(mapcanvas);

        var coords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

        var options = {
            zoom: 15,
            center: coords,
            mapTypeControl: false,
            navigationControlOptions: {
                style: google.maps.NavigationControlStyle.SMALL
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("mapcontainer"), options);

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
