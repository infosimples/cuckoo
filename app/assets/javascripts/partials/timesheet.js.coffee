jQuery ->
  $("#datepicker").datepicker
    onSelect: (dateText, inst) ->
      [month, day, year] = dateText.split('/')
      window.location = "/timesheet/#{year}/#{month}/#{day}"

  $(".icon-calendar").on 'click', ->
    $('#datepicker').toggle()

  #
  # Time entry modal (generic scripts)
  #
  timeEntryModal = $('#timeEntryModal')
  timeEntryForm = timeEntryModal.find('form').first()

  timeEntryForm.on 'ajax:before', ->
    if timeEntryModal.data('form-type') == 'create'
      timeEntryForm.attr('action', '/time_entries.json')
      timeEntryForm.attr('method', 'POST')
    else if timeEntryModal.data('form-type') == 'update'
      timeEntryForm.attr('action', '/time_entries/' + timeEntryModal.data('entry-id') + '.json')
      timeEntryForm.attr('method', 'PUT')

  timeEntryForm.on 'ajax:beforeSend', ->
    Loading.show()

  timeEntryForm.on 'ajax:complete', ->
    Loading.hide()
    timeEntryModal.modal('hide')

  timeEntryForm.on 'ajax:error', (event, data, status) ->
    if status == 422
      html_messages = "<ul>"
      $.each data.responseJSON, (i, message) ->
        html_messages += "<li>#{message}</li>"
      html_messages += "</ul>"
    else
      html_messages = '<p><strong>Something wrong has happened</strong></p>'

    $('#time-entry-form-errors .messages').html(html_messages)
    $('#time-entry-form-errors').show()

  timeEntryForm.on 'ajax:success', (event, data) ->
    if timeEntryModal.data('form-type') == 'create'
      new_entry = create_time_entry(data)
      $('#timesheet-table').show()
      $('#no-day-entries-alert').hide()
      $('tr:not(.hide) .stop-button-container:not(.hide)').children('.stop-button').trigger('click')
      $('#timesheet-table tbody tr').eq(data.position).after(new_entry)
    else if timeEntryModal.data('form-type') == 'update'
      update_time_entry(data)

  #
  # Shared by time entries scripts
  #
  timesheet_table = $('#timesheet-table')

  populate_time_entry_row = (entry_row, time_entry) ->
    entry_row.attr('data-entry-id', time_entry.id)
    entry_row.attr('data-project-id', time_entry.project.id)
    entry_row.attr('data-task-id', time_entry.task.id)
    entry_row.attr('data-description', time_entry.description)
    entry_row.attr('data-start-time', time_entry.start_time)
    entry_row.attr('data-end-time', time_entry.end_time)
    entry_row.attr('data-is-billable', time_entry.is_billable)

    if time_entry.is_billable
      entry_row.find('.billable').show()
    else
      entry_row.find('.billable').hide()

    entry_row.find('.project-name').html(time_entry.project.name)
    entry_row.find('.task-name').html(time_entry.task.name)

    if !$.isEmptyObject time_entry.description
      entry_row.find('.description-devider').show()
    description = entry_row.find('.time-entry-description')
    description.find('.description-text').html(time_entry.description)
    description.show()

    entry_row.find('.start-time').html(time_entry.start_time)

    if !$.isEmptyObject(time_entry.end_time)
      entry_row.find('.count-holder').addClass('stopped')
      entry_row.find('.end-time').html(time_entry.end_time)
      entry_row.find('.stop-button-container').hide()
      entry_row.find('.start-button-container').show()

    mins = Math.floor(time_entry.duration / 60) % 60
    hours = Math.floor(time_entry.duration / 3600)
    entry_row.find('.count-hours').find('.first-digit').children().html(Math.floor(hours / 10))
    entry_row.find('.count-hours').find('.second-digit').children().html(hours % 10)
    entry_row.find('.count-minutes').find('.first-digit').children().html(Math.floor(mins / 10))
    entry_row.find('.count-minutes').find('.second-digit').children().html(mins % 10)

    entry_row.find('.stop-button').attr('href', '/time_entries/' + time_entry.id + '/finish.json')

  #
  # Scripts for creating a new time entry
  #
  $('#new-time-entry-btn').on 'click', ->
    timeEntryModal.data('form-type', 'create')
    show_create_time_entry_modal()

  show_create_time_entry_modal = ->
    $('#time-entry-form-errors').hide()
    timeEntryModal.find('.new-time-form').show()
    timeEntryModal.find('.edit-time-form').hide()
    # reset text fields
    fields_to_reset = '#time-entry-description, #time-entry-start-time, #time-entry-end-time'
    timeEntryModal.find(fields_to_reset).val('')
    # reset checkboxes
    timeEntryModal.find(':checkbox').attr('checked', false)

  create_time_entry = (time_data)->
    entry_row = $('#time-entry-sample').clone()
    entry_row.removeAttr('id')
    entry_row.removeClass('hide')

    populate_time_entry_row(entry_row, time_data)

    delete_time_entry_link = entry_row.find('.delete-time-entry')
    delete_time_entry_link.attr('href', '/time_entries/' + time_data.id)

    return entry_row

  #
  # Scripts for editing an existing time entry
  #
  timesheet_table.on 'click', '.edit-time-entry', ->
    timeEntryModal.data('form-type', 'update')

    entry_row = $(this).parents('tr')
    entry_id = entry_row.attr('data-entry-id')
    project = entry_row.attr('data-project-id')
    task = entry_row.attr('data-task-id')
    description = entry_row.attr('data-description')
    start_time = entry_row.attr('data-start-time')
    end_time = entry_row.attr('data-end-time')
    billable = entry_row.attr('data-is-billable')

    timeEntryModal.find('#time-entry-project').val(project)
    timeEntryModal.find('#time-entry-task').val(task)
    timeEntryModal.find('#time-entry-description').val(description)
    timeEntryModal.find('#time-entry-start-time').val(start_time)
    timeEntryModal.find('#time-entry-end-time').val(end_time)
    if billable == "true"
      timeEntryModal.find('#time-entry-is-billable').attr('checked', billable)

    timeEntryModal.data('entry-id', entry_id)

    show_edit_time_entry_modal()

  show_edit_time_entry_modal = ->
    $('#time-entry-form-errors').hide()
    timeEntryModal.find('.new-time-form').hide()
    timeEntryModal.find('.edit-time-form').show()

  update_time_entry = (time_data) ->
    $.each $('#timesheet-table tbody tr'), (i, row) ->
      if $(row).data('entry-id') == time_data.id
        populate_time_entry_row($(row), time_data)

  #
  # Scripts for deleting time entries
  #
  timesheet_table.on 'ajax:success', '.delete-time-entry', ->
    entry_row = $(this).parents('tr')
    entry_row.fadeOut 'slow', ->
      entry_row.remove()
      if $('#timesheet-table tbody tr').not('.hide').size() == 0
        timesheet_table.hide()
        $('#no-day-entries-alert').fadeIn()

  #
  # Scripts for time entries Start and Stop buttons
  #
  timesheet_table.on 'click', '.start-button', ->
    entry_row = $(this).parents('tr')
    hsh = {
      time_entry: {
        project_id: entry_row.attr('data-project-id'),
        task_id: entry_row.attr('data-task-id'),
        description: entry_row.attr('data-description'),
        is_billable: "false"
      }
      year: timesheet_table.attr('data-year'),
      month: timesheet_table.attr('data-month'),
      day: timesheet_table.attr('data-day')
    }
    $.post('/time_entries.json', hsh).success (data) ->
      $('tr:not(.hide) .stop-button-container:not(.hide)').children('.stop-button').trigger('click')
      new_entry = create_time_entry(data)
      $('#timesheet-table tbody tr').eq(data.position).after(new_entry)

  timesheet_table.on 'ajax:success', '.stop-button', (event, data) ->
    $(this).parents('.timer-button').children('.start-button-container').removeClass('hide')
    $(this).parents('tr').find('.end-time').html(data.ended_at)
    $(this).parent().addClass('hide')



