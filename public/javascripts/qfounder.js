// load jqueryref.js before this

  $jq = jQuery.noConflict();

  $jq(document).ready(function(){

// clone first row of qfounders
      $jq("button#cloneit").click(function(){
// calculate number of items with tr (id qfdrX) in table
          var tlen = $jq("table#fdr > * > tr.rmable").length;
          if (tlen > 9) {
            alert("Maximum 10 founders.");
            return;
          }
// calculate next index from last tr, avoid duplicate names, ids
          var lastid = $jq("table#fdr > * > tr.rmable").last().attr("id");
          var ct = new Number(lastid.match("[0-9]+")) + 1;

// clone first row
//        $jq("tr#qfdr0").clone().appendTo("table#fdr").addClass("workin");

// set id of new tr, clear input fields, reset checkbox
//        $jq(".workin").each( function() {
//          $(this).id = $(this).id.replace("0",ct);
//        });
//        var tid = $jq(".workin").attr("id");
// if jQuery.noConflict not used, line below fails
//        $jq(".workin > * > input").val("");
//        $jq(".workin > * > .chk").val("1").attr("checked","");

// set id of Remove button, bind new action
//        $jq(".workin > * > button.rmable").each( function() {
//          $(this).id = $(this).id.replace("0",ct);
//        });
//        $jq(".workin > * > button.rmable").bind('click', function() {
//          btn = "tr#"+tid+".rmable";
//          $jq(btn).remove();
//        });

// relabel all input names and ids w/ new index ct
//        $jq(".workin > * > input").each( function() {
//          $(this).id = $(this).id.replace("0",ct);
//          $(this).name = $(this).name.replace("0",ct);
//        });
//        $jq(".workin").removeClass("workin");

// append explicit elements, avoid "clear" for rmit0 clone
//        ct += 1;
          var elem = '<tr class="rmable" id="qfdr'+ct+'">';
          elem += '<td></td>';
          elem += '<td><input id="qfounder_'+ct+'_firstname" name="qfounder['+ct+'][firstname]" size="12" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_lastname" name="qfounder['+ct+'][lastname]" size="12" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_role" name="qfounder['+ct+'][role]" size="20" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_willcode" name="qfounder['+ct+'][willcode]" type="hidden" />';
          elem += '<input class="chk" id="qfounder_'+ct+'_willcode" name="qfounder['+ct+'][willcode]" type="checkbox" value="1" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_weblink" name="qfounder['+ct+'][weblink]" size="30" type="text" value="" /></td>';
          elem += '<td></td>';
          elem += '<td><button class="rmable" id="rmit'+ct+'">Remuve</button></td>';
          elem += '</tr>';
          $jq(elem).appendTo("table#fdr").addClass("workin");
          var tid = $jq(".workin").attr("id");

// bind new action
          $jq(".workin > * > button.rmable").bind('click', function() {
            btn = "tr#"+tid+".rmable";
            $jq(btn).remove();
          });
          $jq(".workin").removeClass("workin");
      });

// set up Remove buttons
      $jq("button#rmit0.rmable").click(function(){
// clear input fields instead of remove()
//        $jq("tr#qfdr0.rmable > * > *").val("");
//        $jq("tr#qfdr0.rmable > * > .chk").val("1").attr("checked","");
          $jq("tr#qfdr0.rmable").remove();
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

