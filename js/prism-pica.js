// syntax highlighting of PICA Plain format
(function (Prism) {
  Prism.languages.pica = {

    // title-revision format
    inserted: /^\+.*$/m, 
    deleted: /^-.*$/m,

    // tag and optional occurrence
    field: {
      pattern: /^\s*([012][0-9]{2}[A-Z@](\/[0-9]{2,3})?)/m,
      inside: {
        punctation: /\//,
        keyword: /[^\/]+/
      }
    },

    // PICA Path Expression 
    path: {
      pattern: /^\s*([012.][0-9.]{2}[A-Z@.](\/[0-9]{2,3})?).+/m,
      inside: {
        punctation: /[\/\[\]]/,
        subfields: {
          pattern: /(\$)[^$]+/,
          lookbehind: 1,
          inside: {
            punctation: /^$/,
            property: /.+/,
          }
        },
        keyword: /.+/,
      }
    },

    subfield: {
      pattern: /\$[^$]([^$\n]+|\$\$)*/,
      inside: {
        property: {
          pattern: /(\$)[^$]/,
          lookbehind: 1
        },
        string: /([^$]+|\$\$)+/,
        punctation: /^\$/,          
      }
    },
  }
}(Prism))
