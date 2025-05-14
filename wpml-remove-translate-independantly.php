
<?php 

// Auto remove WPML duplicate post flag
add_action('save_post', 'wpml_flag_post_for_independence', 99, 2);

function wpml_flag_post_for_independence($post_id, $post) {
    if (defined('DOING_AUTOSAVE') && DOING_AUTOSAVE) return;
    
    // Delay removal until after everything else has run
    add_action('shutdown', function() use ($post_id) {
        $duplicate_of = get_post_meta($post_id, '_icl_lang_duplicate_of', true);
        if (!empty($duplicate_of)) {
            delete_post_meta($post_id, '_icl_lang_duplicate_of');
        }
    });
}
