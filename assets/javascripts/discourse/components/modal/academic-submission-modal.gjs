/** @ts-check */
import Component from "@glimmer/component";
import DModal from "discourse/components/d-modal";
import AcademicSubmissionForm from "../academic-submission-form";

export default class AcademicSubmissionModal extends Component {
  <template>
    <DModal
      @title="js.academic_repository.form.title"
      @closeModal={{@closeModal}}
      class="academic-submission-modal"
    >
      <:body>
        <AcademicSubmissionForm @onSuccess={{@closeModal}} />
      </:body>
    </DModal>
  </template>
}