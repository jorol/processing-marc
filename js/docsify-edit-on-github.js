;(function(win) {
  win.EditOnGithubPlugin = {}

  function create(docEditBase, title) {
    title = title || 'Edit on github'

    function editDoc(event, vm) {
      var docName = vm.route.file

      if (docName) {
        var editLink = docEditBase + docName
        window.open(editLink)
        event.preventDefault()
        return false
      } else {
        return true
      }
    }

    win.EditOnGithubPlugin.editDoc = editDoc

    function generateHeader(title) {
      return header = [
        '<div style="overflow: auto">',
        '<p style="float: right"><a style="text-decoration: underline; cursor: pointer"',
        'onclick="EditOnGithubPlugin.onClick(event)">',
        title,
        '</a></p>',
        '</div>'
      ].join('')
    }

    return function(hook, vm) {
      win.EditOnGithubPlugin.onClick = function(event) {
        EditOnGithubPlugin.editDoc(event, vm)
      }

      var header = generateHeader(title)
      hook.afterEach(function (html) {
        return header + html
      })
    }
  }

  win.EditOnGithubPlugin.create = create
}) (window)
