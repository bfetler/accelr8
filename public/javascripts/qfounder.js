// load the following in jqueryref.js:
// google.load("jquery", "1.5.0");
// google.load("jqueryui", "1.8.9");

  $jq = jQuery.noConflict();

  $jq(document).ready(function(){

// to debug, just add <span id="msg">msg</span> to html
// and uncomment $jq("span#msg") sections
      $jq("button#cloneit").click(function(){
// calculate number of items with tr (id qfdrX) in table
          var tlen = $jq("table#fdr > * > tr.rmable").length; // ha
          if (tlen > 9) {
            alert("Maximum 10 founders.");
            return;
          }
// calculate next index from last tr used, to avoid duplicate names, ids
          var lastid = $jq("table#fdr > * > tr.rmable").last().attr("id");
          var ct = new Number(lastid.match("[0-9]+")) + 1;

// clone(true) binds previous events, but need to bind new event
          $jq("tr#qfdr0").clone().appendTo("table#fdr").addClass("workin");

// set id of new tr, clear input fields, reset checkbox
//        $jq(".workin").attr("id", $jq(".workin").attr("id").replace("0",ct));
          $jq(".workin").each( function() {
            $(this).id = $(this).id.replace("0",ct);
          });
          var tid = $jq(".workin").attr("id");
          $jq(".workin > * > input").val("");
          $jq(".workin > * > .chk").val("1").attr("checked","");
//        $jq("span#msg").text( function(i, val) {
//          return val + " msg: fdr tr ct "+ct+"; tlen "+tlen+"; tid "+tid+"; ";
//        });

// set id of Remove button, bind new action
          $jq(".workin > * > button.rmable").each( function() {
            $(this).id = $(this).id.replace("0",ct);
          });
          $jq(".workin > * > button.rmable").bind('click', function() {
            btn = "tr#"+tid+".rmable";
            $jq(btn).remove();
          });
//        $jq("span#msg").text( function(i, val) {
//          var bid = $jq(".workin > * > button.rmable").attr("id");
//          var btn = "tr#"+tid+".rmable.remove()";
//          return val + " abid "+bid+", action "+btn+"; ";
//        });

// relabel all input names and ids w/ new index ct
          $jq(".workin > * > input").each( function() {
            $(this).id = $(this).id.replace("0",ct);
            $(this).name = $(this).name.replace("0",ct);
          });
//        $jq("span#msg").text( function(i, val) {
//          $jq(".workin > * > input").each( function() {
//            val += $(this).id+" " + $(this).name+" ";
//          });
//          return val + " xx";
//        });
          $jq(".workin").removeClass("workin");
      });

// set up Remove buttons
      $jq("button#rmit0.rmable").click(function(){
// clear input fields instead of remove()
          $jq("tr#qfdr0.rmable > * > *").val("");
          $jq("tr#qfdr0.rmable > * > .chk").val("1").attr("checked","");
      });
// put into a loop?
      $jq("button#rmit1.rmable").click(function(){
          $jq("tr#qfdr1.rmable").remove();
      });
      $jq("button#rmit2.rmable").click(function(){
          $jq("tr#qfdr2.rmable").remove();
      });
      $jq("button#rmit3.rmable").click(function(){
          $jq("tr#qfdr3.rmable").remove();
      });
      $jq("button#rmit4.rmable").click(function(){
          $jq("tr#qfdr4.rmable").remove();
      });
      $jq("button#rmit5.rmable").click(function(){
          $jq("tr#qfdr5.rmable").remove();
      });
      $jq("button#rmit6.rmable").click(function(){
          $jq("tr#qfdr6.rmable").remove();
      });
      $jq("button#rmit7.rmable").click(function(){
          $jq("tr#qfdr7.rmable").remove();
      });
      $jq("button#rmit8.rmable").click(function(){
          $jq("tr#qfdr8.rmable").remove();
      });
      $jq("button#rmit9.rmable").click(function(){
          $jq("tr#qfdr9.rmable").remove();
      });

  });  // end $jq(document).ready

