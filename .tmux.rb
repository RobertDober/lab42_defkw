require 'lab42/tmux/auto_import'

def vi base_dir='.', colorscheme: nil, cmds: [], &block
  new_window "vi_#{base_dir}" do
    send_keys "vi #{base_dir}"
    cmds = cmds.push ":colorscheme #{colorscheme}" if colorscheme
    cmds.each do | cmd |
      sleep 0.1
      send_keys ":#{cmd}"
    end
    block.() if block
  end
end

config do
  pre_wait_interval 0.1
  post_wait_interval 0.1
  wait_timeout 4
  verbose true
end
new_session "KwFuns" do
  after_new_window do
#    send_keys 'rvm use @Lab42Core --create'
  end
  vi colorscheme: :morning
  vi 'lib', colorscheme: :solarized, cmds: ['set background=dark']
  new_window 'test'
  vi 'test', colorscheme: 'solarized'
    # wait_for "up a dir" do   # 2B replaced by wait_for_NERDTree
    #   send_keys_raw 'C-w', 'l'         # 2B replaced with vi_move_pane_right
    #   send_keys ':e proud.md'
    #   send_keys ':so proud.vim'
    #   send_keys_raw 'ziG'
    # end
  new_window 'console' do
    send_keys 'iex -S mix'
  end
  new_window 'etc'
end
