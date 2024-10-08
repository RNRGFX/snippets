// Use https://shancarter.github.io/mr-data-converter/ (JSON Column arrays) to create list from excel

let list = ['url1' 'url2' ...];

jQuery('#icl-tm-translation-dashboard .post-title').each(function(i, el){
    href = jQuery(this).find('.view a').attr('href');
    if (list.includes(href)){        
        jQuery(this).prev().find('input[type=checkbox]').prop( "checked", true );
    }
});
