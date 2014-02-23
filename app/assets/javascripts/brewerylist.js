var BREWERIES = {};

BREWERIES.show = function() {
    $("#brewerytable tr:gt(0)").remove();

    var table = $("#brewerytable");

    $.each(BREWERIES.list, function(index, brewery) {
        table.append('<tr>'
            + '<td>' +brewery['name'] +'</td>'
            + '<td>' +brewery['year'] +'</td>'
            + '<td>' +brewery['beer_count'] +'</td>'
            + '</tr>'
        )
    });
};

BREWERIES.sort_by_name = function() {
    BREWERIES.list.sort(function (a,b) {
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
}

BREWERIES.sort_by_year = function() {
    BREWERIES.list.sort(function (a,b) {
        return a.year > b.year;
    });
}

BREWERIES.sort_by_beer_count = function() {
    BREWERIES.list.sort(function (a,b) {
        return a.beer_count < b.beer_count;
    });
}

$(document).ready(function() {

    $("#brw_name").click(function (e) {
        BREWERIES.sort_by_name();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#brw_year").click(function (e) {
        BREWERIES.sort_by_year();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#brw_beers").click(function (e) {
        BREWERIES.sort_by_beer_count();
        BREWERIES.show();
        e.preventDefault();
    });


    if( $("#brewerytable").length > 0) {
        $.getJSON('breweries.json', function (breweries) {
            BREWERIES.list = breweries;
            BREWERIES.sort_by_name();
            BREWERIES.show();
        });
    }
});