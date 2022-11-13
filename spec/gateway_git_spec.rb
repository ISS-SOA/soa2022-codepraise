# frozen_string_literal: true

require_relative 'helpers/spec_helper'

CLONE_COMMAND = 'git clone --progress ssh://__.git ./test 2>&1'
BLAME_COMMAND = 'git blame --line-porcelain test.rb'

describe 'Unit test of git command gateway' do
  it 'should make the right clone command' do
    command = CodePraise::Git::Command.new
      .clone('ssh://__.git', './test')
      .with_std_error
      .with_progress
      .full_command

    _(command).must_equal CLONE_COMMAND
  end

  it 'should make the right blame command' do
    command = CodePraise::Git::Command.new
      .with_porcelain
      .blame('test.rb')
      .full_command

    _(command).must_equal BLAME_COMMAND
  end
end
