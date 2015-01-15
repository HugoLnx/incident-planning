module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    markdown: {
      all: {
        files: [
          {
            expand: true,
            src: 'src/*.md',
            dest: 'build/html/',
            ext: '.html'
          }
        ]
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-markdown');

  // Default task(s).
  grunt.registerTask('default', ['markdown']);

};
