if !exists('g:test#ruby#rspec#file_pattern')
  let g:test#ruby#rspec#file_pattern = '\v(_spec\.rb|spec/.*\.feature)$'
endif

function! test#ruby#rspec#test_file(file) abort
  return a:file =~# g:test#ruby#rspec#file_pattern
endfunction

function! test#ruby#rspec#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#rspec#build_args(args) abort
  let args = a:args

  if exists('g:test#ruby#rspec#smart_root')
    let parts = split(args[-1], '/')
    let spec_dir_index = index(parts, 'spec')
    let spec_dir = join(parts[spec_dir_index:len(parts)-1], '/')

    if len(args) == 1
      let args = [spec_dir]
    else
      let rest = args[0:len(args)-2]
      let args = rest + [spec_dir]
    endif
  endif

  if test#base#no_colors()
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#ruby#rspec#executable() abort
  if !empty(glob('.zeus.sock'))
    return 'zeus rspec'
  elseif filereadable('./bin/rspec')
    return './bin/rspec'
  elseif filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
    return 'bundle exec rspec'
  else
    return 'rspec'
  endif
endfunction
