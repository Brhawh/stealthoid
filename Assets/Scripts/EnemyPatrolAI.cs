using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyPatrolAI : MonoBehaviour {

	public Transform[] patrolPoints;
	public float speed;

	Transform currentPatrolPointTarget;
	int currentPatrolPointTargetIndex;

	// Use this for initialization
	void Start () {
		currentPatrolPointTarget = patrolPoints [0];
		currentPatrolPointTargetIndex = 0;
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate (Vector3.up * Time.deltaTime * speed);

		if (Vector3.Distance (transform.position, currentPatrolPointTarget.position) < 1f) {
			if (currentPatrolPointTargetIndex + 1 < patrolPoints.Length) {
				currentPatrolPointTargetIndex++;
			} else {
				currentPatrolPointTargetIndex = 0;
			}
			currentPatrolPointTarget = patrolPoints [currentPatrolPointTargetIndex];
		}

		Vector3 patrolPointDirection = currentPatrolPointTarget.position - transform.position;
		float angle = Mathf.Atan2 (patrolPointDirection.y, patrolPointDirection.x) * Mathf.Rad2Deg - 90f;

		Quaternion q = Quaternion.AngleAxis (angle, Vector3.forward);
		transform.rotation = Quaternion.RotateTowards (transform.rotation, q, 180f);
	}
}
