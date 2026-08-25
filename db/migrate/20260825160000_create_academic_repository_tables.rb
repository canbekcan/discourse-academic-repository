# frozen_string_literal: true

class CreateAcademicRepositoryTables < ActiveRecord::Migration[7.0]
  def change
    create_table :academic_works do |t|
      t.integer :work_type, default: 0, null: false
      t.string :title, null: false
      t.text :abstract
      t.string :doi
      t.string :isbn
      t.string :issn
      t.date :publication_date
      t.string :venue_name
      t.string :volume
      t.string :issue
      t.string :pages
      t.string :edition
      t.string :publisher_location
      t.string :institution
      t.string :degree_level
      t.string :advisor
      t.bigint :created_by_user_id
      t.jsonb :raw_metadata, default: {}
      t.timestamps
    end
    add_index :academic_works, :doi, unique: true

    create_table :academic_authors do |t|
      t.string :given_name
      t.string :family_name, null: false
      t.string :orcid
      t.string :email
      t.string :affiliation
      t.bigint :matched_user_id
      t.timestamps
    end
    add_index :academic_authors, :orcid
    add_foreign_key :academic_authors, :users, column: :matched_user_id

    create_table :academic_work_authors do |t|
      t.bigint :academic_work_id, null: false
      t.bigint :academic_author_id, null: false
      t.integer :author_order, default: 1
      t.boolean :is_corresponding, default: false
    end
    add_index :academic_work_authors, [:academic_work_id, :academic_author_id], unique: true, name: 'idx_work_authors_unique'
    add_foreign_key :academic_work_authors, :academic_works
    add_foreign_key :academic_work_authors, :academic_authors

    create_table :academic_citations do |t|
      t.bigint :source_work_id, null: false
      t.bigint :target_work_id
      t.string :target_doi
      t.text :raw_reference_text
      t.timestamps
    end
    add_index :academic_citations, :source_work_id
    add_index :academic_citations, :target_work_id
    add_index :academic_citations, :target_doi
    add_foreign_key :academic_citations, :academic_works, column: :source_work_id
    add_foreign_key :academic_citations, :academic_works, column: :target_work_id

    create_table :user_academic_profiles do |t|
      t.bigint :user_id, null: false
      t.bigint :academic_work_id, null: false
      t.integer :role, default: 0, null: false
      t.timestamps
    end
    add_index :user_academic_profiles, [:user_id, :academic_work_id], unique: true, name: 'idx_user_academic_profiles_unique'
    add_foreign_key :user_academic_profiles, :users
    add_foreign_key :user_academic_profiles, :academic_works
  end
end