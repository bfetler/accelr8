// load jqueryref.js before this

  $jq = jQuery.noConflict();

  function not_first_in_table() {
    var len = $jq("table#fdr > * > tr.rmable").length;
    if (len < 2) {
      alert("Minimum 1 founder, cannot remove.");
//    event.preventDefault();
//    event.stopPropagation();
//    event.stopImmediatePropagation();
      return false;
    }
    else
    {
      return true;
    }
  }

  $jq(document).ready(function(){

// clone qfounders row
      $jq("button#addrow").click(function(){
// calculate number of items with tr (id qfdrX) in table
          var tlen = $jq("table#fdr > * > tr.rmable").length;
          if (tlen > 9) {
            alert("Maximum 10 founders.");
            return;
          }

// calculate next index from last tr, avoid duplicate names, ids
          var lastid = $jq("table#fdr > * > tr.rmable").last().attr("id");
          var ct = new Number(lastid.match("[0-9]+")) + 1;

// append elements
          var elem = '<tr class="rmable nomargin" id="qfdr'+ct+'">';
          elem += '<td></td>';
          elem += '<td><input id="qfounder_'+ct+'_firstname" name="qfounder['+ct+'][firstname]" size="12" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_lastname" name="qfounder['+ct+'][lastname]" size="12" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_role" name="qfounder['+ct+'][role]" size="16" type="text" value="" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_willcode" name="qfounder['+ct+'][willcode]" type="hidden" />';
          elem += '<input class="chk" id="qfounder_'+ct+'_willcode" name="qfounder['+ct+'][willcode]" type="checkbox" value="1" /></td>';
          elem += '<td><input id="qfounder_'+ct+'_weblink" name="qfounder['+ct+'][weblink]" size="30" type="text" value="" /></td>';
          elem += '<td><button class="rmable" id="rmit'+ct+'">Remove</button></td>';
          elem += '</tr>';
          $jq(elem).appendTo("table#fdr").addClass("workin");
          var tid = $jq(".workin").attr("id");

// bind new action
          $jq(".workin > * > button.rmable").bind('click', function() {
            var len = $jq("table#fdr > * > tr.rmable").length;
            if (len < 2) {
              alert("Minimum 1 founder, cannot remove.");
              return false;
            }
            var btn = "tr#"+tid+".rmable";
            $jq(btn).remove();
//          if (not_first_in_table())  // fails, flips to new page
//            $jq("tr#"+tid+".rmable").remove();
          });
          $jq(".workin").removeClass("workin");
      });

// set up initial Remove buttons
      $jq("button.rmable").click(function(){
          if (not_first_in_table())
            var bnum = $(this).id.match("[0-9]+");
            $jq("tr#qfdr"+bnum+".rmable").remove();
      });

  });  // end $jq(document).ready

