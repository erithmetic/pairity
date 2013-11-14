require 'spec_helper'
require 'tempfile'
require 'pairity'

describe Pairity do

  describe '.with_key_paths' do

    context 'with a static file' do

      it 'yields a single path' do
        Pairity.root = Dir.mktmpdir
        key = File.open File.join(Pairity.root, 'secret-one.key'), 'w'
        key.puts 'SECRET VALUE ONE'
        key.close

        Pairity.with_key_paths 'SECRET_ONE' do |path|
          path.should == key.path
        end
      end

      it 'yields multiple paths' do
        Pairity.root = Dir.mktmpdir
        key1 = File.open File.join(Pairity.root, 'secret-one.key'), 'w'
        key1.puts 'SECRET VALUE ONE'
        key1.close

        key2 = File.open File.join(Pairity.root, 'secret-two.key'), 'w'
        key2.puts 'SECRET VALUE TWO'
        key2.close

        Pairity.with_key_paths 'SECRET_ONE', 'SECRET_TWO' do |one, two|
          one.should == key1.path
          two.should == key2.path
        end
      end

    end

    context 'with an env value' do

      it 'yields a single path' do
        ENV['SINGLE_SECRET_ONE'] = 'SECRET VALUE ONE'

        Pairity.with_key_paths 'SECRET_ONE' do |path|
          File.read(path).should == "SECRET VALUE ONE\n"
        end
      end

      it 'yields multiple paths' do
        ENV['MULTIPLE_SECRET_ONE'] = 'MSECRET VALUE ONE'
        ENV['MULTIPLE_SECRET_TWO'] = 'MSECRET VALUE TWO'

        Pairity.with_key_paths 'multiple_secret_one', 'MULTIPLE_SECRET_TWO' do |one, two|
          File.read(one).should == 'MSECRET VALUE ONE'
          File.read(two).should == 'MSECRET VALUE TWO'
        end
      end

    end

  end

  describe '.with_keys' do

    context 'with a static file' do

      it 'yields a single value' do
        Pairity.root = Dir.mktmpdir
        key = File.open File.join(Pairity.root, 'secret-one.key'), 'w'
        key.puts 'SECRET VALUE ONE'
        key.close

        Pairity.with_keys 'SECRET_ONE' do |one|
          one.should == "SECRET VALUE ONE\n"
        end
      end

      it 'yields multiple paths' do
        Pairity.root = Dir.mktmpdir
        key1 = File.open File.join(Pairity.root, 'secret-one.key'), 'w'
        key1.puts 'SECRET VALUE ONE'
        key1.close

        key2 = File.open File.join(Pairity.root, 'secret-two.key'), 'w'
        key2.puts 'SECRET VALUE TWO'
        key2.close

        Pairity.with_key_paths 'SECRET_ONE', 'SECRET_TWO' do |one, two|
          one.should == key1.path
          two.should == key2.path
        end
      end

    end

    context 'with an env value' do

      it 'yields a single path' do
        ENV['SINGLE_SECRET_ONE'] = 'SECRET VALUE ONE'

        Pairity.with_key_paths 'SINGLE_SECRET_ONE' do |path|
          File.read(path).should == 'SECRET VALUE ONE'
        end
      end

      it 'yields multiple paths' do
        ENV['MULTIPLE_SECRET_ONE'] = 'MSECRET VALUE ONE'
        ENV['MULTIPLE_SECRET_TWO'] = 'MSECRET VALUE TWO'

        Pairity.with_key_paths 'multiple_secret_one', 'MULTIPLE_SECRET_TWO' do |one, two|
          File.read(one).should == 'MSECRET VALUE ONE'
          File.read(two).should == 'MSECRET VALUE TWO'
        end
      end

    end

  end

end

