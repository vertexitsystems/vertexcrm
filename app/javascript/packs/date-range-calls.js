var prev_value = "";
document.addEventListener("turbolinks:load", () => {
    var flag = true;
    $('[data-tooltip-display="true"]').tooltip(),
	flatpickr("#close_consultant_field_date", {
		mode: "single",
		dateFormat: "Y-m-d",
		allowInput: false,
		monthSelectorType: "static"
	}),
    flatpickr("#date-range-work,#date-range-work-report", {
      mode: "range",
      dateFormat: "Y-m-d",
		allowInput: false,
		monthSelectorType: "static",
			onClose: function(selectedDates, dateStr, instance){
				$("#filter_load_indicator").show();
			    }
    }),
    $("#previous_weeks").on("click", function(event) {
      $(this).parents('ul').hide();
      $("#back").parents('ul').show();
    }),
    $("#back").on("click", function(event) {
      $(this).parents('ul').hide();
      $("#previous_weeks").parents('ul').show();
    }),
    $('#date-range-work').change(function(d) {
		//alert("Something: " + d.target.value + " prev_value " + prev_value);
		
		if (prev_value == "") {
			prev_value = d.target.value
			return
		} else {
			//alert("load data with dates: " + d.target.value);
			var split_dates = d.target.value.split(" to ");
			var current_url = window.location.protocol + '//' + window.location.host + window.location.pathname;

      var searchString = window.location.search.substring(1);
      var params = searchString.split("&");
      var old_params = "";
      if (searchString != ""){
        for (var i = 0; i < params.length; i++) {
          var val = params[i].split("=");

          // if (val[1] == ""){
          //   continue;
          // }
          //alert("val[0]: " + val[0] + " result " + (val[0] != "from_date") );
          if (val[0] != "from_date" && val[0] != "to_date"){
            old_params += ("&" + params[i]);
          }
        }
      }

      //alert("ur: "+old_params);

			if (split_dates.length > 1) {
				
				window.location.replace(current_url+"?from_date="+split_dates[0]+"&to_date="+split_dates[1]+old_params);
			} else {
				//alert("Date: start:" + split_dates[0] + ", End: " + split_dates[0]);
				window.location.replace(current_url+"?from_date="+split_dates[0]+"&to_date="+split_dates[0]+old_params);
			}

			prev_value= ""
			
		}
//         var val = d.target.value
//         if (d.target.name.includes("time_sheet")){
//           var url = "/account_managers/time_sheet_approval.js"
//         }else if(d.target.name.includes("employee")){
//           var id = d.target.name.split("_")
//           var url = "/employees/"+id[id.length-1]+".js"
//         }
//         if(val.includes("to")){
//           var data = val.split(" to ")
//           $.ajax({
//             type: "GET",
//             url: url,
//             data:{"from_date":data[0],"to_date":data[1]},
//             success: function(data) {
//
//             },
//             error: function(data) {
//             }
//           });
//         }
    }),
    $('#date-range-work-report').change(function(d) {
        var val = d.target.value
        if(val.includes("to")){  
          var data = val.split(" to ")
          $.ajax({
            type: "GET",
            url: "/account_managers/vendor_wise_data.js",
            data:{"from_date":data[0],"to_date":data[1]},
            success: function(data) {

            },
            error: function(data) {
            }
          });
        }
    }),
    $('#time_sheet').change(function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/time_sheet_approval.js",
        data:{"status_filter": event.target.value},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $('#time_sheet_report').change(function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/vendor_wise_data.js",
        data:{"status_filter": event.target.value},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $('#vendor_name').change(function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/vendor_wise_data.js",
        data:{"vendor_name": event.target.value},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $('.value_duration').keyup(function(event) {
      var index = event.currentTarget.dataset.index;
      var current_val = parseInt(event.currentTarget.value || '0');
      var max_limit = parseInt(event.currentTarget.max)
      var min_limit = parseInt(event.currentTarget.min)
      if(current_val < min_limit || current_val > max_limit){
        $(this).val($(this).val().split('')[0]);
      }
      // var ret = parseInt($("#work_duration_a1").val() || '0') + parseInt($("#work_duration_b1").val() || '0') + parseInt($("#work_duration_c1").val() || '0') + parseInt($("#work_duration_d1").val() || '0') + parseInt($("#work_duration_e1").val() || '0')
      // $("#total_hours").html(ret);
      var total_hours = 0;
      $(".emp-duration-"+index).each(function(index,input){
        total_hours += parseInt(input.value || '0');
      });
      $("#total-hours-"+index).html(total_hours);
    }),
    $('#tab1').on("click",function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/vendor_wise_data.js",
        data:{"biweekly": true},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $('#tab2').on("click",function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/vendor_wise_data.js",
        data:{"monthly": true},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $('#tab3').on("click",function(event) {
      $.ajax({
        type: "GET",
        url: "/account_managers/vendor_wise_data.js",
        data:{"quartarly": true},
        success: function(data) {
         
        },
        error: function(data) {
        }
      });
    }),
    $("#wizard-picture").change(function(){
        readURL(this);
    }),
	
	

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#wizardPicturePreview').attr('src', e.target.result).fadeIn('slow');
        }
        reader.readAsDataURL(input.files[0]);
    }
}



})