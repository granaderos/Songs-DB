$(document).ready(function() {

    // $.ajaxSetup({
    //     headers: {"X-CSRFToken": getCookie("csrftoken")},

    // });

    $("#btn_add_playlist").click(function(e) {
        var form = $(this).closest("form");
        var title = $("#playlist_name").val();
        $.ajax({
            url: "playlist/add/",
            method: "POST",
            //data: form.serialize(),
            data: {"title": title, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success adding playlist: " + JSON.stringify(data));
            },
            error: function(data) {
                console.log("Error in adding playlist: " + JSON.stringify(data));
            }
        })
    });

    
});

function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) c_end = document.cookie.length;
            return unescape(document.cookie.substring(c_start,c_end));
        }
    }
    return "";
 }
