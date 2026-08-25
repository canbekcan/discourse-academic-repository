# frozen_string_literal: true

AcademicRepository::Engine.routes.draw do
  resources :academic_works, only: [:create] do
    collection do
      get 'resolve_doi' => 'academic_works#resolve_doi'
    end
  end
end