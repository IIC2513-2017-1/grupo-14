$(document).on('turbolinks:load', function() {
      var value_index
      var max_fields      = 20;
      var wrapper         = $(".values");
      var add_button      = $(".add_form_field");
    
      var x = 1;
      $('.add_form_field').on('click', function(e){
          e.preventDefault();
          if(x < max_fields){
              x++;
              $(wrapper).append('<div class="field"><label>Choice</label><div class="extra_choice"><input required="required" type="text" name="bet[choices_attributes][][value]"><a href="#" class="delete choice">Delete</a></div></div>'); //add input box
          }
    else
    {
    alert("Can't add more choices")
    }
      });
    
      $(wrapper).on("click",".delete", function(e){
          e.preventDefault(); $(this).parent('div').parent('div').remove(); x--;
      })
  });

//Fields generables obtenidos de http://www.sanwebcorner.com/2017/02/dynamically-generate-form-fields-using.html