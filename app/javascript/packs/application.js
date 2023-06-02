// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap")
require("flatpickr")
require("packs/date-range-calls.js")
import flatpickr from "flatpickr";
import("styles/application.scss")
import("styles/tabs.css")
import 'select2'
import 'select2/dist/css/select2.css'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//import "trix"
//import "@rails/actiontext"

document.addEventListener("turbolinks:load", function() {
	Turbolinks.clearCache();
	bind_filters();
	bind_date_selectors();
	bind_phonenumber_formatter();
	bind_intellisense();
	bind_validations();
	bind_submit_button_active();
})

function bind_submit_button_active(){
	$('#first_name_field, #last_name_field ,#contact_field, #email_field, #employee_employer_rate, #rate_field, #employee_contract_type_c2c, #employee_contract_type_w2, #employee_contract_type_1099').on('keyup change', function() {
		if(allFilled()) {
			$('#submit_button_create_consultant').removeAttr('disabled');
			$('#submit_button_create_consultant').removeClass('button_disabled');
		} else {
			$('#submit_button_create_consultant').attr('disabled', true);
			$('#submit_button_create_consultant').addClass('button_disabled');
		}
	});
}

function matchPattern(elem, pattern) {
	return !pattern.test(elem.val());
}

function allFilled() {
    var filled = true;
	var contact_pattern = /[0-9]{3}-[0-9]{3}-[0-9]{4}/i
    $('#first_name_field, #last_name_field ,#contact_field, #email_field, #employee_employer_rate, #rate_field').each(function() {
        var blank_validation    = $('#first_name_field').val() == '' || $('#last_name_field').val() == '' ||  $('#contact_field').val() == '' ||  $(' #email_field').val() == '';
		var pattern_validation  = matchPattern($('#contact_field'), /[0-9]{3}-[0-9]{3}-[0-9]{4}/i);
        var email_pattern_vall  = matchPattern($('#email_field'), /[a-zA-Z0-9-._]+@[a-zA-Z-._]+\.[a-zA-Z]{2,5}$/i);
		var emp_rate_validation = $("#rate_field").is(":hidden") && $("#employee_contract_type_c2c").is(':checked') && $("#employee_employer_rate").val() == '';
		var con_rate_validation = !$("#employee_contract_type_c2c").is(':checked') && $("#rate_field").val() == '';

		if (blank_validation || pattern_validation || emp_rate_validation || con_rate_validation || email_pattern_vall) filled = false;
		console.log("blank_validation: " + blank_validation + ", pattern_validation: " + pattern_validation + ", emp_rate_validation: " + emp_rate_validation + ", con_rate_validation: " + con_rate_validation);
    });

	
	
    return filled;
}

// submit_button.addEventListener("submit", (event) => {
// 	event.preventDefault();
//     alert("Submit alert");
	
//   });
// $("#submit_button_create_consultant").click(function(elem){
// 	var all_ok = true;
// 	if ($("#first_name_field").val() == "" ||
// 		$("#last_name_field").val() == "" ||
// 		$("#contact_field").val() == "" ||
// 		$("#email_field").val() == ""){
// 		all_ok = false;

// 		validate_required($("#first_name_field"), true);
// 		validate_required($("#last_name_field"), true);
// 		validate_required($("#contact_field"), true);
// 		validate_required($("#email_field"), true);

// 	}
// 	if ( $("#employee_contract_type_c2c").is(':checked') && $("#employee_employer_rate").val() == ""){
// 		all_ok = false;
// 	}
// 	if ( !$("#employee_contract_type_c2c").is(':checked') && $("#rate_field").val() == ""){
// 		all_ok = false;
// 	}
	
// 	return all_ok;
	

// });

function validate_required(elem, req){
	
	var show_error = $(elem).val() == "";

	if (req && show_error){
		
		$(elem).css("border-color", '#dc3545')
		var title_elem = $($(elem).siblings(".field_title")[0]);
		title_elem.css("color","red");
		if (typeof $(elem).siblings(".required_message")[0] === "undefined") {
			$(elem).after("<div class='required_message'>This Field is required</div>");
		}
		
	} else {
		
		$(elem).css("border-color", '#ced4da')

		var title_elem = $($(elem).siblings(".field_title")[0]);
		title_elem.css("color","black");

		//$($(this).siblings(".required_message")[0]).hide()
		$($(elem).siblings(".required_message")[0]).remove()
	}
}

function bind_validations(){
	$(".force_validate_required").on("focusout", function(elem){
		
		validate_required(this, true);
	});
	$(".validate_required").on("focusout", function(elem){
		
		var req = ($(this).attr("required") == "required");
		
		
		//console.log("req: " + req + ", err: " + show_error);
		validate_required(this, req);
	});
	// $(".validate_required").focusout(function(elem){
	// 	alert("check" + $(elem).attr("a"));
	// });
}
function bind_intellisense(){
	$('.intellisence_select2').select2();
	// $(document).ready(function() {
		
	// });
}

function bind_filters() {
	$('.pagination_link').click(function () {
		var new_page = $(this).attr("new_page");
		loadURL(constructParams("page", new_page));
	});
    
	$('.sorting_link').on('click', function (event) {
		//var vend_id = $(this).val();
		var param_sort  = $(this).attr("sort_type");
		var param_order = $(this).attr("order_type");
		
		var url_first = constructParams("sort", param_sort);
		var url_final = constructParamsWithUrl(url_first, "order", param_order);
		
		loadURL(url_final);

		event.preventDefault();
		return false;
	});


	  $('.flex_col input[type=text]').on('blur', function () {
		$('#alert').text('Enter more than 3 characters!');
	});

	$('.filter_field').on('change', function () {
		var vend_id = $(this).val();
		var param_name = $(this).attr("filter_name");
		loadURL(constructParams(param_name, vend_id));
	});
	
	$('.employee_job_dropdown').on('change', function () {
		
		$.get("/jobs/fetch_vendor_info.json?id="+$(this).val(), function(data, status){
			//alert("Data: " + data["client"]["name"] + "\nStatus: " + status);

			$('#vendor_name_display').html(data["vendor"]["name"]);
			$('#client_name_display').html(data["client"]["name"]);
			
		  });
	});

	$(".parent-toggle").on("click",function(event){
		if ($(event.target).is("div")){
			
			
			var id = this.dataset.index;
			$(".labeled-toggle-"+id).toggle();
			$(".field-toggle-"+id).toggle();
			
			// var total_hours = 0;
			// if(flag){
			// 	$(".emp-duration-"+id).each(function(index,input){
			// 		total_hours += parseInt(input.value || '0');
			// 	});
			//
			// 	flag = false;
			// }
			// else{
			// 	$(".label-duration-"+id).each(function(index,input){
			// 		total_hours += parseInt(input.text || '0');
			// 	});
			// 	flag = true;
			// }
			//
			// $("#total-hours-"+id).html(total_hours);
			// $("#"+this.lastElementChild.attributes.id.nodeValue).slideToggle(500);
		}
	})
}
function bind_date_selectors(){
	flatpickr(".date_select_field", {
		mode: "single",
		dateFormat: "Y-m-d",
		defaultDate:'null',
		allowInput: false,
		monthSelectorType: "static"
	});
	flatpickr(".date_range_field", {
		mode: "range",
		dateFormat: "Y-m-d",
		defaultDate:'null',
		allowInput: false,
		monthSelectorType: "static"
	});
}
function bind_popup_image(){
	$(document).ready(function() {
		$("#profile_picture_image").click(function(e) {
		    e.preventDefault();
			$("#image_popup").css({"visibility":"visible","opacity":"1"});
		});
	});
}
function bind_phonenumber_formatter(){
	$(".filtered_phone_number").on("input", function() {
	   var value = $(this).val();
	   
	   // remove dashes and readd them each time... This is needed to ensure consistant result when user deletes characters
	   value = value.replace(/\-/g, "");
	   
	   for (const item of [3,7]) {
		   if (value.length > item && value[item] != "-"){
			   var v = value
			   value = [value.slice(0, item), "-", value.slice(item)].join('');
			   
		   }
	   }
	   
	   $(this).val(value);
	   
	   // Remove non-numerical characters and any characters above length 12 (12 accounts for two dashes aswell) 
	   if (!$.isNumeric(value[value.length - 1]) || value.length > 12){
		   var output = value.slice(0, Math.min((value.length - 1), 12) );
		   $(this).val(output);
		   return;
	   }
	   
	});
}

function constructParams(param_key, param_value){
	var searchString = window.location.search.substring(1);
	return constructParamsWithUrl(searchString, param_key, param_value);
}

function constructParamsWithUrl(url, param_key, param_value){
	var searchString = url;
	var params = searchString.split("&");
	var new_params = "";

	 var found = false;

	if (searchString != ""){
		for (var i = 0; i < params.length; i++) {
			var val = params[i].split("=");
			if (unescape(val[0]) == param_key){
				found = true;

				if (param_value == ""){
					continue;
				}

				new_params += val[0] + "=" +  param_value;

			} else {
				new_params += val[0] + "=" +  val[1];
			}
			if ((params.length > i + 1) || !found){ new_params += "&"; }
		}
	}

	if (!found){ new_params += param_key + '=' + param_value; }

	return new_params
}

// function constructParams2(param_key, param_value){
// 	var searchString = window.location.search.substring(1);
// 	var params = searchString.split("&");
// 	var new_params = "";

// 	 var found = false;

// 	if (searchString != ""){
// 		for (var i = 0; i < params.length; i++) {
// 			var val = params[i].split("=");
// 			if (unescape(val[0]) == param_key){
// 				found = true;

// 				if (param_value == ""){
// 					continue;
// 				}

// 				new_params += val[0] + "=" +  param_value;

// 			} else {
// 				new_params += val[0] + "=" +  val[1];
// 			}
// 			if ((params.length > i + 1) || !found){ new_params += "&"; }
// 		}
// 	}

// 	if (!found){ new_params += param_key + '=' + param_value; }

// 	return new_params
// }

function loadURL(with_params){
	window.location = location.protocol + '//' + location.host + location.pathname + "?" + with_params;
	return false

}
require("trix")
require("@rails/actiontext")