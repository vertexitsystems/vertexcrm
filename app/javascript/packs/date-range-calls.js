var prev_value = "";
document.addEventListener("turbolinks:load", () => {
    var flag = true;
    $('[data-tooltip-display="true"]').tooltip(),

	flatpickr("#close_consultant_field_date", {
		mode: "single",
		dateFormat: "Y-m-d",
		allowInput: true,
		monthSelectorType: "static"
	}),
    flatpickr("#date-range-work,#date-range-work-report", {
      mode: "range",
      dateFormat: "Y-m-d",
		allowInput: true,
		monthSelectorType: "static"
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
			if (split_dates.length > 1) {
				
				window.location.replace(current_url+"?from_date="+split_dates[0]+"&to_date="+split_dates[1]);
			} else {
				//alert("Date: start:" + split_dates[0] + ", End: " + split_dates[0]);
				window.location.replace(current_url+"?from_date="+split_dates[0]+"&to_date="+split_dates[0]);
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
	
	$(".parent-toggle").on("click",function(event){
		if ($(event.target).is("div")){
			
			
			var id = this.dataset.index;
			$(".labeled-toggle-"+id).toggle();
			$(".field-toggle-"+id).toggle();
			
			var total_hours = 0;
			if(flag){
				$(".emp-duration-"+id).each(function(index,input){
					total_hours += parseInt(input.value || '0');
				});
				
				flag = false;
			}
			else{
				$(".label-duration-"+id).each(function(index,input){
					total_hours += parseInt(input.text || '0');
				});
				flag = true;
			}
			
			$("#total-hours-"+id).html(total_hours);
			$("#"+this.lastElementChild.attributes.id.nodeValue).slideToggle(500);
		}
	})

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