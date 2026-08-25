/** @ts-check */
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import AcademicSubmissionModal from "../components/modal/academic-submission-modal";

export default class AddAcademicWorkConnector extends Component {
  @service modal;
  @service currentUser;

  // Sadece kullanıcının kendi profilindeyse butonu göster
  get shouldShow() {
    return this.currentUser && this.currentUser.id === this.args.outletArgs.user.id;
  }

  @action
  openSubmissionModal() {
    this.modal.show(AcademicSubmissionModal);
  }
}

<template>
  {{#if this.shouldShow}}
    <li class="add-academic-work-btn">
      <DButton
        @icon="book"
        @label="js.academic_repository.button.add_publication"
        @action={{this.openSubmissionModal}}
        class="btn-primary"
      />
    </li>
  {{/if}}
</template>